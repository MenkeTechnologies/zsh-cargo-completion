alias co=cargo
alias cr='cargo run'
alias ccl='cargo clean'
alias ccy='cargo clippy'
alias cb='cargo build --release'
alias ct='cargo test'
alias cad='cargo add'
alias ci='cargo install'
alias ciu='cargo install-update -a'
alias cfi='cargo fix'
alias cfm='cargo fmt'
alias cfe='cargo fetch'
alias cpa='cargo package'
alias cpl='cargo publish'
alias cs='cargo search'
alias cfa='cargo fmt; cargo fix --allow-dirty --allow-staged'


0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

fpath=("${0:h}/src" $fpath)
