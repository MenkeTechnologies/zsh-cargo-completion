```
 ███████╗███████╗██╗  ██╗
 ╚══███╔╝██╔════╝██║  ██║
   ███╔╝ ███████╗███████║
  ███╔╝  ╚════██║██╔══██║
 ███████╗███████║██║  ██║
 ╚══════╝╚══════╝╚═╝  ╚═╝
       [ c a r g o ]
```

[![CI](https://github.com/MenkeTechnologies/zsh-cargo-completion/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/zsh-cargo-completion/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![zsh](https://img.shields.io/badge/zsh-plugin-cyan.svg)](https://github.com/MenkeTechnologies/zpwr)

### `[CARGO COMPLETION FOR ZSH // REMOTE CRATE SEARCH VIA TAB]`

> *"`cargo add <TAB>` and `cargo install <TAB>` query the crates.io index live."*

**zsh-cargo-completion** ships every OMZ cargo completion plus a live `cargo search`-backed completer for `cargo add` and `cargo install`. Type `cargo add <TAB>` and the remote crate index is queried in real time.

### [`strykelang`](https://github.com/MenkeTechnologies/strykelang) &middot; [`zshrs`](https://github.com/MenkeTechnologies/zshrs) · [`MenkeTechnologiesMeta`](https://github.com/MenkeTechnologies/MenkeTechnologiesMeta) · [`zsh-more-completions`](https://github.com/MenkeTechnologies/zsh-more-completions) · [`zsh-better-npm-completion`](https://github.com/MenkeTechnologies/zsh-better-npm-completion) · [`zsh-gem-completion`](https://github.com/MenkeTechnologies/zsh-gem-completion) · [`zpwr`](https://github.com/MenkeTechnologies/zpwr)

### [`Read the Docs`](https://menketechnologies.github.io/zsh-cargo-completion/) &middot; [`Engineering Report`](https://menketechnologies.github.io/zsh-cargo-completion/report.html)

---

## Table of Contents

- [\[0x00\] `> DEMO_`](#0x00-demo_)
- [\[0x01\] `> ALIASES_`](#0x01-aliases_)
- [\[0x02\] `> INSTALL_`](#0x02-install_)

---

## [0x00] `> DEMO_`

![cargo add rand <tab>](cargoadd.png)

> `cargo add` / `cargo install` + `<TAB>` queries **`cargo search`** and completes remote crate names in real time.

---

## [0x01] `> ALIASES_`

```zsh
# ── CORE ──────────────────────────────────────────────
alias co=cargo                  # base command
alias cr='cargo run'            # run project
alias cb='cargo build'          # build
alias cbr='cargo build --release'

# ── CODE QUALITY ──────────────────────────────────────
alias ct='cargo test'           # run tests
alias ccy='cargo clippy'        # lint
alias cfm='cargo fmt'           # format
alias cfi='cargo fix'           # auto-fix
alias cfa='cargo fix --allow-dirty --allow-staged;cargo clippy --all-targets --fix -- -D warnings; cargo fmt'

# ── DEPENDENCIES ──────────────────────────────────────
alias cad='cargo add'           # add crate
alias ci='cargo install'        # install binary
alias ciu='cargo install-update -a' # update installed
alias cs='cargo search'         # search crates.io
alias cfe='cargo fetch'         # fetch dependencies

# ── PUBLISH ───────────────────────────────────────────
alias cpa='cargo package'       # package crate
alias cpl='cargo publish'       # publish to crates.io
alias ccl='cargo clean'         # clean target/
```

---

## [0x02] `> INSTALL_`

<details>
<summary><b>// ZINIT (RECOMMENDED) //</b></summary>

> `~/.zshrc`
```zsh
source "$HOME/.zinit/bin/zinit.zsh"
zinit ice lucid nocompile
zinit load MenkeTechnologies/zsh-cargo-completion
```

</details>

<details>
<summary><b>// OH MY ZSH //</b></summary>

```sh
cd "$HOME/.oh-my-zsh/custom/plugins" && git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git
```

Add `zsh-cargo-completion` to the plugins array in `~/.zshrc`

</details>

<details>
<summary><b>// MANUAL //</b></summary>

```sh
git clone https://github.com/MenkeTechnologies/zsh-cargo-completion.git
```

Source `zsh-cargo-completion.plugin.zsh` from your `~/.zshrc` or any startup script.

</details>

---

