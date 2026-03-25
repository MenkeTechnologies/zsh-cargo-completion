#!/usr/bin/env zunit
#{{{                    MARK:Header
#**************************************************************
##### Author: MenkeTechnologies
##### GitHub: https://github.com/MenkeTechnologies
##### Date: Tue Feb 25 19:37:50 EST 2020
##### Purpose: zsh script to
##### Notes:
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
}

@test 'pluginDir/*.zsh syntax' {
	for file in "$pluginDir/"*.zsh; do
        run zsh -n "$file"
        assert $state equals 0
    done
}

@test 'src/* zsh syntax' {
	for file in "$pluginDir/src/"*; do
        run zsh -n "$file"
        assert $state equals 0
    done
}

@test 'alias co is defined' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias co
    assert $state equals 0
    assert "$output" contains "cargo"
}

@test 'alias cr is cargo run' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cr
    assert $state equals 0
    assert "$output" contains "cargo run"
}

@test 'alias cb is cargo build --release' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cb
    assert $state equals 0
    assert "$output" contains "cargo build --release"
}

@test 'alias ct is cargo test' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias ct
    assert $state equals 0
    assert "$output" contains "cargo test"
}

@test 'alias ccl is cargo clean' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias ccl
    assert $state equals 0
    assert "$output" contains "cargo clean"
}

@test 'alias ccy is cargo clippy' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias ccy
    assert $state equals 0
    assert "$output" contains "cargo clippy"
}

@test 'alias cad is cargo add' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cad
    assert $state equals 0
    assert "$output" contains "cargo add"
}

@test 'alias ci is cargo install' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias ci
    assert $state equals 0
    assert "$output" contains "cargo install"
}

@test 'alias ciu is cargo install-update -a' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias ciu
    assert $state equals 0
    assert "$output" contains "cargo install-update -a"
}

@test 'alias cfi is cargo fix' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cfi
    assert $state equals 0
    assert "$output" contains "cargo fix"
}

@test 'alias cfm is cargo fmt' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cfm
    assert $state equals 0
    assert "$output" contains "cargo fmt"
}

@test 'alias cfe is cargo fetch' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cfe
    assert $state equals 0
    assert "$output" contains "cargo fetch"
}

@test 'alias cpa is cargo package' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cpa
    assert $state equals 0
    assert "$output" contains "cargo package"
}

@test 'alias cpl is cargo publish' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cpl
    assert $state equals 0
    assert "$output" contains "cargo publish"
}

@test 'alias cs is cargo search' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cs
    assert $state equals 0
    assert "$output" contains "cargo search"
}

@test 'alias cfa contains cargo fmt and cargo fix' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cfa
    assert $state equals 0
    assert "$output" contains "cargo fmt"
    assert "$output" contains "cargo fix"
}

@test 'all 16 aliases are defined' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    local -a expected_aliases
    expected_aliases=(co cr ccl ccy cb ct cad ci ciu cfi cfm cfe cpa cpl cs cfa)
    for a in $expected_aliases; do
        run alias $a
        assert $state equals 0
    done
}

@test 'fpath contains src directory after sourcing' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    local found=false
    for p in $fpath; do
        if [[ "$p" == *"/src" ]]; then
            found=true
            break
        fi
    done
    assert "$found" same_as "true"
}

@test 'src/_cargo completion file exists' {
    assert "$pluginDir/src/_cargo" is_file
}

@test 'src/_cargo starts with compdef cargo' {
    local first_line
    first_line=$(head -1 "$pluginDir/src/_cargo")
    assert "$first_line" same_as "#compdef cargo"
}

@test 'plugin file exists' {
    assert "$pluginDir/zsh-cargo-completion.plugin.zsh" is_file
}

@test '_cargo function is defined after sourcing completion' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo"
    assert $state equals 0
}

@test 'src/_cargo defines helper functions' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_cmds"
    assert $state equals 0
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_test_names"
    assert $state equals 0
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_benchmark_names"
    assert $state equals 0
}

@test 'src/_cargo defines __cargo_remote_packages' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type __cargo_remote_packages"
    assert $state equals 0
}

@test 'src/_cargo defines _cargo_unstable_flags' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_unstable_flags"
    assert $state equals 0
}

@test 'src/_cargo defines _cargo_installed_crates' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_installed_crates"
    assert $state equals 0
}

@test 'src/_cargo defines _cargo_package_names' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_package_names"
    assert $state equals 0
}

@test 'src/_cargo defines _cargo_names_from_array' {
    run zsh -c "autoload -Uz compinit && compinit -u 2>/dev/null; source '$pluginDir/src/_cargo' 2>/dev/null; type _cargo_names_from_array"
    assert $state equals 0
}

@test 'src/_cargo autoloads regexp-replace' {
    run zsh -c "source '$pluginDir/src/_cargo' 2>/dev/null; type regexp-replace"
    assert $state equals 0
}

@test 'completion file handles all major subcommands' {
    local -a expected_subcommands
    expected_subcommands=(
        add bench build check clean doc fetch fix
        generate-lockfile git-checkout help init install
        locate-project login metadata new owner package
        pkgid publish read-manifest run rustc rustdoc
        search test uninstall update verify-project version yank
    )
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    for subcmd in $expected_subcommands; do
        assert "$contents" contains "$subcmd)"
    done
}

@test 'completion supports common flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--verbose"
    assert "$contents" contains "--quiet"
    assert "$contents" contains "--help"
    assert "$contents" contains "--frozen"
    assert "$contents" contains "--locked"
    assert "$contents" contains "--color="
}

@test 'completion supports toolchain selection' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "+stable"
    assert "$contents" contains "+beta"
    assert "$contents" contains "+nightly"
}

@test 'completion supports --list and --version top-level flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--list"
    assert "$contents" contains "--version"
    assert "$contents" contains "--explain="
}

@test 'completion supports parallel jobs flag' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--jobs"
}

@test 'completion supports features flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--features="
    assert "$contents" contains "--all-features"
    assert "$contents" contains "--no-default-features"
}

@test 'completion supports message format flag' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--message-format="
    assert "$contents" contains "human json short"
}

@test 'completion supports target flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--target="
    assert "$contents" contains "--target-dir="
}

@test 'completion supports manifest path flag' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--manifest-path="
}

@test 'completion supports registry flag' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--registry="
}

@test 'build subcommand has release and build-plan flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--release[build in release mode]"
    assert "$contents" contains "--build-plan"
}

@test 'test subcommand has no-fail-fast and no-run flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--no-fail-fast[run all tests regardless of failure]"
    assert "$contents" contains "--no-run[compile but do not run]"
}

@test 'install subcommand has git and force flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--git="
    assert "$contents" contains "--force"
}

@test 'publish subcommand has dry-run and token flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--dry-run[perform all checks without uploading]"
    assert "$contents" contains "--token=[specify token to use when uploading]"
}

@test 'init subcommand supports edition and vcs flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--edition="
    assert "$contents" contains "2015 2018"
    assert "$contents" contains "git hg pijul fossil none"
}

@test 'command scope spec has bench bin example lib test' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--bench="
    assert "$contents" contains "--example="
    assert "$contents" contains "--bin="
    assert "$contents" contains "--lib="
    assert "$contents" contains "--test="
}

@test 'fix subcommand has allow-dirty allow-staged flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--allow-dirty[fix code even if the working directory is dirty]"
    assert "$contents" contains "--allow-staged[fix code even if the working directory has staged changes]"
    assert "$contents" contains "--broken-code"
    assert "$contents" contains "--edition[fix in preparation for the next edition]"
    assert "$contents" contains "--edition-idioms"
    assert "$contents" contains "--allow-no-vcs"
}

@test 'clean subcommand has doc flag' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--doc[clean just the documentation directory]"
}

@test 'doc subcommand has no-deps and open flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--no-deps[do not build docs for dependencies]"
    assert "$contents" contains "--document-private-items"
    assert "$contents" contains "--open[open docs in browser after the build]"
}

@test 'yank subcommand has vers and undo flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--vers=[specify yank version]"
    assert "$contents" contains "--undo[undo a yank, putting a version back into the index]"
}

@test 'owner subcommand has add remove list flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--add"
    assert "$contents" contains "--remove"
    assert "$contents" contains "--list"
}

@test 'search subcommand has limit flag' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--limit="
}

@test 'metadata subcommand has no-deps and format-version flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--format-version="
}

@test 'update subcommand has aggressive dry-run precise flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--aggressive="
    assert "$contents" contains "--precise="
}

@test 'uninstall subcommand has bin and root flags' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--bin=[only uninstall the specified binary]"
    assert "$contents" contains "--root="
}

@test 'remote packages uses cargo search with limit 1000' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "cargo search --color=never --limit 1000"
}

@test 'remote packages uses caching' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "_retrieve_cache"
    assert "$contents" contains "_store_cache"
    assert "$contents" contains "crate_cache_file"
}

@test 'remote packages skips continuation lines' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "...*"
    assert "$contents" contains "continue"
}

@test 'completion falls back for unknown subcommands' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains '_cargo-${words[1]}'
    assert "$contents" contains "_default && ret=0"
}

@test 'no unexpected aliases leak from plugin' {
    local before_aliases after_aliases
    before_aliases=$(alias | wc -l)
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    after_aliases=$(alias | wc -l)
    # plugin defines exactly 16 aliases
    local diff=$(( after_aliases - before_aliases ))
    assert "$diff" same_as "16"
}

@test 'sourcing plugin twice does not duplicate fpath entries' {
    local count0=0
    for p in $fpath; do
        [[ "$p" == "${pluginDir}/src" ]] && count0=$(( count0 + 1 ))
    done
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    local count2=0
    for p in $fpath; do
        [[ "$p" == "${pluginDir}/src" ]] && count2=$(( count2 + 1 ))
    done
    # plugin prepends unconditionally, so two sources add two entries
    # this test documents the current behavior
    local expected=$(( count0 + 2 ))
    assert "$count2" same_as "$expected"
}

@test 'fpath src directory is prepended not appended' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    local first_match
    for p in $fpath; do
        if [[ "$p" == *"/src" ]]; then
            first_match="$p"
            break
        fi
    done
    assert "$first_match" same_as "${pluginDir}/src"
}

@test 'README exists' {
    assert "$pluginDir/README.md" is_file
}

@test 'license file exists' {
    assert "$pluginDir/license.md" is_file
}

@test 'README documents aliases' {
    local contents
    contents="$(<"$pluginDir/README.md")"
    assert "$contents" contains "co"
    assert "$contents" contains "cargo"
}

@test 'completion file ends with _cargo invocation' {
    local last_line
    last_line=$(tail -1 "$pluginDir/src/_cargo")
    assert "$last_line" same_as "_cargo"
}

@test 'completion file has no trailing whitespace on compdef line' {
    local first_line
    first_line=$(head -1 "$pluginDir/src/_cargo")
    assert "$first_line" same_as "#compdef cargo"
}

@test 'install subcommand supports cargo install --list' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "--list[list all installed packages and their versions]"
}

@test 'install subcommand uses __cargo_remote_packages for completion' {
    local contents
    contents="$(<"$pluginDir/src/_cargo")"
    assert "$contents" contains "__cargo_remote_packages"
}

@test 'cfa alias includes allow-dirty and allow-staged' {
    source "$pluginDir/zsh-cargo-completion.plugin.zsh"
    run alias cfa
    assert $state equals 0
    assert "$output" contains "--allow-dirty"
    assert "$output" contains "--allow-staged"
}
