# dotfiles

My macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [Homebrew](https://brew.sh/)
- GNU Stow: `brew install stow`
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [mise](https://mise.jdx.dev/) (runtime manager)

## Quick Setup

Fresh Mac? Run the bootstrap script — it installs Homebrew, Oh My Zsh, Powerlevel10k, stows everything, and applies macOS defaults:

```bash
git clone https://github.com/jeanlucaslima/dotfiles.git
cd dotfiles
./bootstrap.sh
```

Already set up? Just stow the dotfiles:

```bash
./install.sh
```

Or stow individual packages:

```bash
stow -t ~ shell
stow -t ~ git
stow -t ~ nvim
```

## Packages

| Package    | What it manages                                |
|------------|------------------------------------------------|
| `shell`    | `.zshrc`, `.bashrc`, `.profile`, `.p10k.zsh`, `.fzf.*` |
| `git`      | `.gitconfig`, `.config/git/ignore`             |
| `nvim`     | Neovim config (LazyVim)                        |
| `ghostty`  | Ghostty terminal config                        |
| `zed`      | Zed editor settings                            |
| `mise`     | mise tool versions (node, python, rust, etc.)  |
| `starship` | Starship prompt config                         |
| `fish`     | Fish shell config                              |
| `ssh`      | SSH config (GitHub key agent)                  |

## How It Works

Each directory is a Stow "package". Running `stow -t ~ <package>` creates symlinks in `$HOME` that point back to the files in this repo. Edits to your config files automatically update the repo.

To remove symlinks: `stow -t ~ -D <package>`

## Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Stow all packages into `$HOME` |
| `bootstrap.sh` | Full fresh-Mac setup (Homebrew, Oh My Zsh, Powerlevel10k, stow, macOS defaults) |
| `macos-defaults.sh` | Apply preferred macOS system settings (Dock, Finder, keyboard, screenshots) |
