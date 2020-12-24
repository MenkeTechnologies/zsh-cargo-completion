# zsh-cargo-completion

This plugin has all functionality of OMZ cargo completion but it also allows `cargo add <tab>` to complete remote crates from output of `cargo search`.

## Install for Zinit
> `~/.zshrc`
```sh
source "$HOME/.zinit/bin/zinit.zsh"
zinit ice lucid nocompile
zinit load MenkeTechnologies/zsh-cargo-completion
```

## Install for Oh My Zsh

```sh
cd "$HOME/.oh-my-zsh/custom/plugins"  && git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git
```

Add `zsh-cargo-completion` to plugins array in ~/.zshrc

## General Install

```sh
git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git
```

source zsh-cargo-completion.plugin.zsh or add code to zshrc or any startup script
