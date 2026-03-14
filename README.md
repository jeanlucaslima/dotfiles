# dotfiles

My macOS dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [Homebrew](https://brew.sh/)
- GNU Stow: `brew install stow`
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [mise](https://mise.jdx.dev/) (runtime manager)

## Quick Setup

```bash
git clone https://github.com/jeanlucaslima/dotfiles.git
cd dotfiles
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

## How It Works

Each directory is a Stow "package". Running `stow -t ~ <package>` creates symlinks in `$HOME` that point back to the files in this repo. Edits to your config files automatically update the repo.

To remove symlinks: `stow -t ~ -D <package>`
