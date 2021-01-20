# My dotfiles

This is my new list of [dotfiles](dotfiles.github.io) for my personal laptop,
right now this is optimized for MacOS. 

Personally, I'm using more `VS Code` lately, but I love me some well set up vim.
I'm using `iTerm2` with `zsh` and `oh-my-zsh`. 

Check the other branchs for my old Ubuntu/Debian dotfiles.

### vim Vundle
You gotta install [Vundle](https://github.com/VundleVim/Vundle.vim) manually.

### zsh extra repos
Install these extra repos to `$ZSH_CUSTOM` folder:

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

And to install `fzf` run this and accept all options (y):
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
```

### Brew

All brew formulas were listed with `brew leaves` and they can be install with a simple bash input
