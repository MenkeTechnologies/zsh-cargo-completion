#!/usr/bin/env zunit
#{{{                    MARK:Header
#**************************************************************
##### Purpose: zsh-cargo-completion alias + completion contract pins.
#####          Aliases live in the plugin file; the completion lives
#####          under src/_cargo. Both surfaces are pinned here.
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    pluginFile="$pluginDir/zsh-cargo-completion.plugin.zsh"
    compFile="$pluginDir/src/_cargo"
}

@test 'plugin adds src/ to fpath via \${0:h}/src (plugin-manager portable)' {
    # Pin: fpath augmentation MUST use ${0:h}/src so the plugin works
    # under oh-my-zsh, zinit, antigen, or bare source.
    local body
    body=$(cat "$pluginFile")
    assert "$body" contains 'fpath=("${0:h}/src" $fpath)'
}

@test '_cargo completion file starts with #compdef cargo' {
    # Pin: without #compdef as the first line, compinit won't pick up
    # the completion when fpath is augmented.
    local first
    first=$(head -1 "$compFile")
    assert "$first" same_as '#compdef cargo'
}

@test 'co is bare cargo (the canonical short form)' {
    # Pin: co = cargo. The user's instinct in zsh-cargo-completion has
    # always been `co build`, `co run`. If renamed (e.g. ca = cargo),
    # 5 years of muscle memory dies.
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias co
    ")
    assert "$body" same_as "co=cargo"
}

@test 'cb is cargo build (NOT --release — that is cbr)' {
    # Pin: cb is bare debug build. cbr is release. Per the user's
    # global CLAUDE.md: 'only use cargo build for local dev, NOT
    # cargo build --release' — cb must stay debug.
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cb
    ")
    assert "$body" same_as "cb='cargo build'"
}

@test 'cbr is cargo build --release (the release-mode escape hatch)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cbr
    ")
    assert "$body" contains 'cargo build'
    assert "$body" contains '--release'
}

@test 'cr is cargo run (NOT cargo run --release)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cr
    ")
    assert "$body" same_as "cr='cargo run'"
}

@test 'ct is cargo test (the canonical test runner)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias ct
    ")
    assert "$body" same_as "ct='cargo test'"
}

@test 'ccy is cargo clippy (NOT cargo check — that is its own alias)' {
    # Pin: cc would collide with `cc` (the C compiler). ccy is the
    # disambiguated clippy alias. Renaming to cc breaks PATH-aware
    # shells that try to alias-expand before command lookup.
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias ccy
    ")
    assert "$body" same_as "ccy='cargo clippy'"
}

@test 'ccl is cargo clean (NOT cargo clippy — that is ccy)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias ccl
    ")
    assert "$body" same_as "ccl='cargo clean'"
}

@test 'cfm is cargo fmt (NOT cargo fix — that is cfi)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cfm
    ")
    assert "$body" same_as "cfm='cargo fmt'"
}

@test 'cfi is cargo fix (NOT cargo fmt — that is cfm)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cfi
    ")
    assert "$body" same_as "cfi='cargo fix'"
}

@test 'cad is cargo add (the dependency-add shortcut)' {
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cad
    ")
    assert "$body" same_as "cad='cargo add'"
}

@test 'ciu is cargo install-update -a (cargo-update plugin batch upgrade)' {
    # Pin: -a means all installed crates. Dropping -a would silently
    # change behaviour to upgrade nothing (install-update needs args).
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias ciu
    ")
    assert "$body" contains 'cargo install-update'
    assert "$body" contains '-a'
}

@test 'cfa is the polish-everything chain: fix + clippy --fix -D warnings + fmt' {
    # Pin: cfa is the user's daily one-shot polish. Three stages MUST
    # stay present + in order: cargo fix --allow-dirty --allow-staged,
    # then cargo clippy --all-targets --fix -- -D warnings, then
    # cargo fmt. Dropping any stage means lint or fmt regressions slip.
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cfa
    ")
    assert "$body" contains 'cargo fix --allow-dirty --allow-staged'
    assert "$body" contains 'cargo clippy --all-targets --fix -- -D warnings'
    assert "$body" contains 'cargo fmt'
}

@test 'cpa = package, cpl = publish (NOT swapped — destructive vs local)' {
    # Pin: cargo publish PUSHES to crates.io. cargo package builds a
    # local .crate. If swapped, `cpa` (instinctively "package") would
    # publish to crates.io — irreversible mistake.
    local pa pl
    pa=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cpa
    ")
    pl=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias cpl
    ")
    assert "$pa" same_as "cpa='cargo package'"
    assert "$pl" same_as "cpl='cargo publish'"
}

@test 'plugin registers >15 c* aliases total' {
    local count
    count=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias | grep -cE '^c[a-zA-Z]*='
    ")
    local result=$([[ "$count" -ge 15 ]] && echo yes || echo "no:$count")
    assert "$result" same_as 'yes'
}

@test 're-sourcing is idempotent (alias count stable)' {
    local first second
    first=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        alias | grep -cE '^c'
    ")
    second=$(zsh -c "
        emulate zsh
        source '$pluginFile'
        source '$pluginFile'
        alias | grep -cE '^c'
    ")
    assert "$first" same_as "$second"
}

@test '_cargo completion file defines remote-package crate fetcher' {
    # Pin: __cargo_remote_packages is the function that fetches
    # crates.io candidates for `cargo add` completion. Removing it
    # silently kills the "live crate name completion" feature.
    local body
    body=$(cat "$compFile")
    assert "$body" contains '__cargo_remote_packages'
    assert "$body" contains 'crate_cache_file'
}

@test '_cargo defines _cargo_cmds (the subcommand-list provider)' {
    # Pin: _cargo_cmds dynamically reads `cargo --list`, so the
    # completion stays current with whatever the user's installed
    # cargo version supports. If a refactor hardcodes a list, the
    # completion goes stale on every cargo update.
    local body
    body=$(cat "$compFile")
    assert "$body" contains '_cargo_cmds()'
    assert "$body" contains 'cargo --list'
}

@test '_cargo completion compiles cleanly under autoload (no syntax errors)' {
    # End-to-end: prove the completion file actually loads under
    # zsh's compsys, not just that the text contains expected tokens.
    local result
    result=$(zsh -c "
        emulate zsh
        fpath=('$pluginDir/src' \$fpath)
        autoload -U _cargo
        autoload +X _cargo && print OK || print FAIL
    " 2>&1)
    assert "$result" same_as 'OK'
}

@test '_cargo handles every statically-completed alias verb (build/run/test/fmt/add/install/fix/publish/search)' {
    # Pin: the aliases would be useless if the completion didn't
    # handle their target subcommands. Verify all STATIC alias-backed
    # verbs appear in the completion file. clippy is intentionally
    # NOT in this list — it's picked up dynamically via
    # `cargo --list` (`_cargo_cmds`) since it ships as a separate
    # rustup component.
    local body
    body=$(cat "$compFile")
    for cmd in build run test fmt add install fix publish search; do
        printf '%s\n' "$body" | grep -q "$cmd"
        assert $? equals 0
    done
}
