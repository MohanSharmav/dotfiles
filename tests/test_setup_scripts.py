"""Checks for setup_mac.sh / setup_ubuntu.sh (and the shared scripts/setup-common.sh).

Run: python3 -m unittest discover -s tests -v
"""

import os
import platform
import re
import subprocess
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SCRIPTS = {"macos": REPO / "setup_mac.sh", "linux": REPO / "setup_ubuntu.sh"}
# The repo itself at a stable path; mise's dotfiles bootstrap has no "." source.
SETUP_ONLY_LINKS = {(".", "~/.config/dotfiles")}
# Created by read-only tool queries even in a dry run; not setup changes.
CACHE_DIRS = {".cache", "Caches", "state"}


def run(args, home=None, **kwargs):
    env = dict(os.environ)
    if home is not None:
        env["HOME"] = str(home)
    return subprocess.run(
        ["bash", *map(str, args)], cwd=REPO, env=env, capture_output=True, text=True, **kwargs
    )


def mise_links(target_os):
    """(source, link) pairs from mise.toml [dotfiles] that apply on target_os.

    A tiny parser for the two entry shapes used there, so this runs on
    Python 3.9 (no tomllib):
      "~/.vimrc" = "nvim/.vimrc"
      "~/.config/skhd" = { source = "skhd", variants = [{ os = "macos" }] }
    """
    text = (REPO / "mise.toml").read_text()
    section = re.search(r"^\[dotfiles\]\n(.*?)(?=^\[)", text, re.S | re.M).group(1)
    links = set()
    for line in section.splitlines():
        line = line.split("#", 1)[0].strip()
        if not line:
            continue
        m = re.fullmatch(r'"([^"]+)"\s*=\s*"([^"]+)"', line)
        if m:
            links.add((m.group(2), m.group(1)))
            continue
        m = re.fullmatch(r'"([^"]+)"\s*=\s*\{\s*source\s*=\s*"([^"]+)".*os\s*=\s*"(\w+)".*\}', line)
        assert m, f"unrecognised mise.toml [dotfiles] line: {line}"
        if m.group(3) == target_os:
            links.add((m.group(2), m.group(1)))
    return links


def script_links(target_os):
    out = run([SCRIPTS[target_os], "--print-links"], home="/HOME")
    assert out.returncode == 0, out.stderr
    links = set()
    for line in out.stdout.splitlines():
        src, dest = line.split("\t")
        links.add((src, dest.replace("/HOME", "~", 1)))
    return links


class LinkMapMatchesMise(unittest.TestCase):
    """setup scripts and `mise run setup-dotfiles` must link the same configs."""

    def test_macos(self):
        self.assertEqual(script_links("macos") - SETUP_ONLY_LINKS, mise_links("macos"))

    def test_linux(self):
        self.assertEqual(script_links("linux") - SETUP_ONLY_LINKS, mise_links("linux"))


class Options(unittest.TestCase):
    def test_help(self):
        for script in SCRIPTS.values():
            out = run([script, "--help"])
            self.assertEqual(out.returncode, 0, script.name)
            self.assertIn("Usage:", out.stdout)

    def test_unknown_option(self):
        for script in SCRIPTS.values():
            self.assertEqual(run([script, "--bogus"]).returncode, 2, script.name)

    def test_wrong_os_refuses(self):
        other = "linux" if platform.system() == "Darwin" else "macos"
        out = run([SCRIPTS[other], "--dry-run"])
        self.assertEqual(out.returncode, 1)
        self.assertIn("setup_", out.stderr)


class MigrateAndSetup(unittest.TestCase):
    """migrate_and_setup.sh runs this OS's setup script with the same options."""

    def test_dispatches_to_this_os(self):
        out = run([REPO / "migrate_and_setup.sh", "--help"])
        self.assertEqual(out.returncode, 0)
        name = "setup_mac.sh" if platform.system() == "Darwin" else "setup_ubuntu.sh"
        self.assertIn(f"./{name}", out.stdout)


class DryRun(unittest.TestCase):
    """--dry-run on this OS plans every step and changes nothing in $HOME."""

    def test_dry_run_changes_nothing(self):
        this_os = "macos" if platform.system() == "Darwin" else "linux"
        with tempfile.TemporaryDirectory() as home:
            out = run([SCRIPTS[this_os], "--dry-run"], home=home, timeout=300)
            self.assertEqual(out.returncode, 0, out.stdout + out.stderr)
            # Tools' own caches from read-only queries (mise env, brew bundle
            # check) are fine; anything else (links, backups, installs) is not.
            created = {
                str(p.relative_to(home))
                for p in Path(home).rglob("*")
                if (p.is_symlink() or p.is_file())
                and not CACHE_DIRS.intersection(p.relative_to(home).parts[:2])
            }
            self.assertEqual(created, set(), "dry run changed $HOME")
            self.assertIn("[dry-run]", out.stdout)
            for step in ("Config links", "mise tools", "Neovim", "tmux", "Verification"):
                self.assertIn(step, out.stdout)


if __name__ == "__main__":
    unittest.main()
