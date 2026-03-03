#!/usr/bin/env bash
# git config with histogram diffs, rerere, diffview mergetool, and work includeif
set -euo pipefail

mkdir -p "$HOME/.config/git"

echo "Writing git config..."

cat > "$HOME/.config/git/config" << 'GITCONFIG'
# See https://git-scm.com/docs/git-config

[user]
	name = kodev
	email = kjortego@gmail.com

[includeIf "gitdir:~/rpc/repo/"]
	path = ~/.gitconfig.work

[init]
	defaultBranch = master

[core]
	autocrlf = false

[pull]
	rebase = false           # Default merge on pull

[push]
	autoSetupRemote = true   # Automatically set upstream branch on push

[diff]
	algorithm = histogram    # Clearer diffs on moved/edited lines
	colorMoved = plain       # Highlight moved blocks in diffs
	mnemonicPrefix = true    # More intuitive refs in diff output

[commit]
	verbose = true           # Include diff comment in commit message template

[column]
	ui = auto 			     # Output in columns when possible

[branch]
	sort = -committerdate    # Sort branches by most recent commit first

[tag]
	sort = -version:refname  # Sort version numbers as you would expect

[rerere]
	enabled = true           # Record and reuse conflict resolutions
	autoupdate = true        # Apply stored conflict resolutions automatically

[merge]
	tool = diffview
[mergetool "diffview"]
	cmd = nvim -n -c \"DiffviewOpen\" \"$MERGE\"
	trustExitCode = true

[color]
	ui = auto
[color "branch"]
	current = yellow reverse
	local = yellow
	remote = green
[color "diff"]
	meta = yellow bold
	frag = magenta bold
	old = red bold
	new = green bold
[color "decorate"]
	HEAD = bold yellow
	branch = bold cyan
	remoteBranch = dim bold cyan
	tag = bold magenta
[color "status"]
	added = green
	changed = yellow
	untracked = cyan

[alias]
	co = checkout
	br = branch
	ci = commit
	st = status
	lg = log --graph --abbrev-commit --decorate --format=format:'%C(bold yellow)%h%C(reset) - %C(dim white)%s%C(reset)%C(auto)%d%C(reset)' --all
	lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold yellow)%h%C(reset) - %C(dim white)%s%C(reset) %C(bold green)- %an%C(reset) %C(dim bold green)(%ar)%C(reset)%C(auto)%d%C(reset)' --all
	lgf = diff-tree --no-commit-id --name-only -r

[filter "lfs"]
	required = true
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
GITCONFIG

echo "  git config: OK"
