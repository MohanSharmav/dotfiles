"""Auto vim-obsession for tmux-resurrect (see "tpope/vim-obsession" in lua/kiyoon/lazy.lua).

Neovim runs in a real tmux pane, as it does for you, and is queried over --listen.
Needs `nvim` (this config installed as ~/.config/nvim, plugins installed), `tmux`, `git`.
Run with: python3 -m unittest discover -s nvim/tests -v
"""

import os
from pathlib import Path
import shlex
import subprocess
import tempfile
import time
import unittest

TMUX_SOCKET_NAME = "nvim-auto-session-test"
STARTUP_TIMEOUT = 60.0


def tmux(*args, check=True):
    return subprocess.run(
        ["tmux", "-L", TMUX_SOCKET_NAME, *args], check=check, capture_output=True, text=True
    ).stdout


class AutoSessionTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # A bare tmux server: the test is about Neovim, not the tmux config.
        tmux("-f", "/dev/null", "new-session", "-d", "-s", "idle")

    @classmethod
    def tearDownClass(cls):
        tmux("kill-server", check=False)

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.dir = Path(self.tmp.name) / "project"
        self.dir.mkdir()
        self.count = 0

    def git_init(self):
        subprocess.run(["git", "init", "-q", str(self.dir)], check=True)

    def start_nvim(self, *args, env=(), unset_tmux=False):
        """Start Neovim in a new tmux pane in self.dir. Returns (session name, socket)."""
        self.count += 1
        name = f"{self._testMethodName}-{self.count}"
        sock = Path(self.tmp.name) / f"{name}.sock"
        cmd = ["env"]
        if unset_tmux:
            cmd += ["-u", "TMUX"]
        cmd += [*env, "nvim", "--listen", str(sock), *args]
        tmux("new-session", "-d", "-s", name, "-x", "160", "-y", "50", "-c", str(self.dir), shlex.join(cmd))
        self.addCleanup(self.stop_nvim, name, sock)

        deadline = time.time() + STARTUP_TIMEOUT
        while time.time() < deadline:
            if sock.exists() and self.expr(sock, "v:vim_did_enter", check=False) == "1":
                # VimEnter has run; give its vim.schedule() callback a moment.
                time.sleep(1.5)
                return name, sock
            time.sleep(0.3)
        self.fail(f"Neovim did not start.\n{self.screen(name)}")

    def stop_nvim(self, name, sock):
        if sock.exists():
            subprocess.run(
                ["nvim", "--server", str(sock), "--remote-send", "<C-\\><C-n>:qa!<CR>"],
                capture_output=True,
                timeout=10,
                check=False,
            )
            deadline = time.time() + 10
            while time.time() < deadline and sock.exists():
                time.sleep(0.2)
        tmux("kill-session", "-t", name, check=False)

    @staticmethod
    def expr(sock, expression, check=True):
        out = subprocess.run(
            ["nvim", "--server", str(sock), "--remote-expr", expression],
            capture_output=True,
            text=True,
            timeout=10,
            check=check,
        )
        return out.stdout.strip()

    @staticmethod
    def screen(name):
        return "--- pane ---\n" + tmux("capture-pane", "-p", "-t", name, check=False)

    def wait_for_session_file(self, timeout=15.0):
        session = self.dir / "Session.vim"
        deadline = time.time() + timeout
        while time.time() < deadline:
            if session.exists():
                return True
            time.sleep(0.2)
        return False

    def assert_tracking(self, name, sock):
        self.assertTrue(self.wait_for_session_file(), f"Session.vim was not created.\n{self.screen(name)}")
        self.assertEqual(self.expr(sock, "exists('g:this_obsession')"), "1", self.screen(name))

    def assert_not_tracking(self, name, sock):
        self.assertFalse((self.dir / "Session.vim").exists(), self.screen(name))
        self.assertEqual(self.expr(sock, "exists('g:this_obsession')"), "0", self.screen(name))

    def test_starts_in_git_repo_inside_tmux(self):
        self.git_init()
        (self.dir / "a.sh").write_text("echo hi\n")
        name, sock = self.start_nvim("a.sh")
        self.assert_tracking(name, sock)
        # tmux-resurrect restores with `nvim -S`; the session must reopen the file.
        self.assertIn("a.sh", (self.dir / "Session.vim").read_text())

    def test_resumes_after_nvim_dash_S(self):
        """What tmux-resurrect runs after a reboot."""
        self.git_init()
        (self.dir / "a.sh").write_text("echo hi\n")
        name, sock = self.start_nvim("a.sh")
        self.assert_tracking(name, sock)
        self.stop_nvim(name, sock)

        name, sock = self.start_nvim("-S")
        self.assertEqual(self.expr(sock, "exists('g:this_obsession')"), "1", self.screen(name))
        self.assertTrue(self.expr(sock, "bufname('%')").endswith("a.sh"), self.screen(name))

    def test_not_outside_tmux(self):
        self.git_init()
        self.assert_not_tracking(*self.start_nvim(unset_tmux=True))

    def test_not_outside_git_repo(self):
        self.assert_not_tracking(*self.start_nvim())

    def test_not_as_git_commit_editor(self):
        self.git_init()
        msg = self.dir / ".git" / "COMMIT_EDITMSG"
        msg.write_text("\n")
        self.assert_not_tracking(*self.start_nvim(str(msg)))

    def test_opt_out_env(self):
        self.git_init()
        self.assert_not_tracking(*self.start_nvim(env=["NVIM_NO_AUTO_SESSION=1"]))


if __name__ == "__main__":
    unittest.main()
