alias cr='cargo run'
alias ccl='cargo clean'
alias ccy='cargo clippy'
alias cb='cargo build --release'
alias ct='cargo test'
alias cad='cargo add'
alias ci='cargo install'
alias cfi='cargo fix'
alias cfm='cargo fmt'
alias cfe='cargo fetch'
alias cp='cargo package'
alias cs='cargo search'


0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

fpath=("${0:h}/src" $fpath)
