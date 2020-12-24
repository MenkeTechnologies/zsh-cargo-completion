# zsh-gem-completion

This plugin has all functionality of OMZ gem completion but it also allows `gem install <tab>` to complete remote gems from output of `gem search`.

## Install for Zinit
> `~/.zshrc`
```sh
source "$HOME/.zinit/bin/zinit.zsh"
zinit ice lucid nocompile
zinit load MenkeTechnologies/zsh-gem-completion
```

## Install for Oh My Zsh

```sh
cd "$HOME/.oh-my-zsh/custom/plugins"  && git clone https://github.com/MenkeTechnologies/zsh-gem-completion.git
```

Add `zsh-gem-completion` to plugins array in ~/.zshrc

## General Install

```sh
git clone https://github.com/MenkeTechnologies/zsh-gem-completion.git
```

source zsh-gem-completion.plugin.zsh or add code to zshrc or any startup script
