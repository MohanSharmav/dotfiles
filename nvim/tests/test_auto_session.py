"""Auto vim-obsession for tmux-resurrect (see "tpope/vim-obsession" in lua/kiyoon/lazy.lua).

Needs `nvim` (with this config installed as ~/.config/nvim and plugins installed),
`tmux`, `git` and `pip install pynvim`.
Run with: python3 -m unittest discover -s nvim/tests -v
"""

import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest

import pynvim

TMUX_SOCKET_NAME = "nvim-auto-session-test"


def start_tmux():
    subprocess.run(["tmux", "-L", TMUX_SOCKET_NAME, "-f", "/dev/null", "new-session", "-d"], check=True)
    out = subprocess.run(
        ["tmux", "-L", TMUX_SOCKET_NAME, "display-message", "-p", "#{socket_path},#{pid},0"],
        check=True,
        capture_output=True,
        text=True,
    )
    return out.stdout.strip()


def stop_tmux():
    subprocess.run(["tmux", "-L", TMUX_SOCKET_NAME, "kill-server"], check=False)


class AutoSessionTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmux_env = start_tmux()

    @classmethod
    def tearDownClass(cls):
        stop_tmux()

    def setUp(self):
        self._old_cwd = os.getcwd()
        self._old_env = dict(os.environ)
        self.tmp = tempfile.TemporaryDirectory()
        self.dir = Path(self.tmp.name)
        os.environ.pop("NVIM_NO_AUTO_SESSION", None)
        os.environ["TMUX"] = self.tmux_env

    def tearDown(self):
        os.chdir(self._old_cwd)
        os.environ.clear()
        os.environ.update(self._old_env)
        self.tmp.cleanup()

    def git_init(self):
        subprocess.run(["git", "init", "-q", str(self.dir)], check=True)

    def open_nvim(self, *args):
        # pynvim starts the child in the current directory with the current environment.
        os.chdir(self.dir)
        nvim = pynvim.attach("child", argv=["nvim", "--embed", *args])
        # Without --headless, Neovim waits for a UI before VimEnter, like a real terminal.
        nvim.ui_attach(120, 40, rgb=True)
        self.addCleanup(self.close_nvim, nvim)
        return nvim

    @staticmethod
    def close_nvim(nvim):
        try:
            nvim.command("qa!")
        except Exception:
            pass  # the connection drops as Neovim exits
        try:
            nvim.close()
        except Exception:
            pass

    def wait_for_session(self, timeout=30.0):
        session = self.dir / "Session.vim"
        deadline = time.time() + timeout
        while time.time() < deadline:
            if session.exists():
                return True
            time.sleep(0.2)
        return False

    def assert_no_session(self, nvim):
        # Let VimEnter + vim.schedule run, then prove Neovim is alive and idle.
        time.sleep(3)
        self.assertEqual(nvim.eval("1 + 1"), 2)
        self.assertFalse((self.dir / "Session.vim").exists())
        self.assertEqual(nvim.eval("exists('g:this_obsession')"), 0)

    def test_starts_in_git_repo_inside_tmux(self):
        self.git_init()
        (self.dir / "a.sh").write_text("echo hi\n")
        nvim = self.open_nvim("a.sh")
        self.assertTrue(self.wait_for_session(), "Session.vim was not created")
        self.assertEqual(nvim.eval("exists('g:this_obsession')"), 1)
        # tmux-resurrect restores with `nvim -S`; the session must contain the file.
        self.assertIn("a.sh", (self.dir / "Session.vim").read_text())

    def test_resumes_after_nvim_dash_S(self):
        self.git_init()
        (self.dir / "a.sh").write_text("echo hi\n")
        first = self.open_nvim("a.sh")
        self.assertTrue(self.wait_for_session())
        self.close_nvim(first)
        time.sleep(1)

        nvim = self.open_nvim("-S", "Session.vim")
        deadline = time.time() + 30
        while time.time() < deadline and nvim.eval("exists('g:this_obsession')") != 1:
            time.sleep(0.2)
        self.assertEqual(nvim.eval("exists('g:this_obsession')"), 1)
        self.assertTrue(nvim.eval("bufname('%')").endswith("a.sh"))

    def test_not_outside_tmux(self):
        self.git_init()
        os.environ.pop("TMUX", None)
        self.assert_no_session(self.open_nvim())

    def test_not_outside_git_repo(self):
        self.assert_no_session(self.open_nvim())

    def test_not_as_git_commit_editor(self):
        self.git_init()
        msg = self.dir / ".git" / "COMMIT_EDITMSG"
        msg.write_text("\n")
        self.assert_no_session(self.open_nvim(str(msg)))

    def test_opt_out_env(self):
        self.git_init()
        os.environ["NVIM_NO_AUTO_SESSION"] = "1"
        self.assert_no_session(self.open_nvim())


if __name__ == "__main__":
    unittest.main()
