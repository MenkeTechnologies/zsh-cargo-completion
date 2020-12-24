alias gemb="gem build *.gemspec"
alias gemp="gem push *.gem"

# gemy GEM 0.0.0 = gem yank GEM -v 0.0.0
function gemy {
	gem yank $1 -v $2
}

0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

fpath=("${0:h}/src" $fpath)
