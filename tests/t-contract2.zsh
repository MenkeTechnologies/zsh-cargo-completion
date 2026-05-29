#!/usr/bin/env zunit
#{{{                    MARK:Header
##### Purpose: zsh-cargo-completion second-tier contracts.
#####          Cover surfaces not yet pinned: _cargo file invocation
#####          contract, alias-name collision check against zsh
#####          builtins, and the lazy `cargo --list` integration.
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    pluginFile="$pluginDir/zsh-cargo-completion.plugin.zsh"
    compFile="$pluginDir/src/_cargo"
}

@test '_cargo file ends with a bare _cargo invocation (autoload contract)' {
    # Pin: zsh autoload of _cargo (function in fpath) requires the
    # last line to invoke `_cargo` so the function body runs on
    # autoload +X. Without it, `compdef _cargo cargo` would not be
    # registered via the autoload path.
    local last
    last=$(grep -vE '^\s*$' "$compFile" | tail -1)
    assert "$last" same_as '_cargo'
}

@test 'no cargo-* alias shadows a zsh builtin or reserved word' {
    # Pin: 17+ aliases starting with c — make sure none collide with
    # builtin/reserved words (cd, command, continue, case, etc.).
    local result
    result=$(zsh -c "
        emulate zsh
        source '$pluginFile' 2>/dev/null
        for name in \${(k)aliases}; do
            [[ \$name == c* ]] || continue
            kind=\$(whence -w \$name 2>/dev/null)
            # an aliased name reports ': alias' — expected.
            # If it ALSO matches a builtin / reserved name, the alias
            # shadows it. Test by un-aliasing then querying.
        done
        unalias -m 'c*' 2>/dev/null
        for name in co cr ccl ccy cb cbr ct cad ci ciu cfi cfm cfe cpa cpl cs cfa; do
            kind=\$(whence -w \$name 2>/dev/null)
            if [[ \"\$kind\" == *': builtin'* || \"\$kind\" == *': reserved'* ]]; then
                print \"COLLISION:\$kind\"
                exit 1
            fi
        done
        print OK
    ")
    assert "$result" same_as 'OK'
}

@test '_cargo_cmds caches results in crate_cache_file (perf contract)' {
    # Pin: the dynamic `cargo --list` call is cached; uncached, every
    # TAB on `cargo <TAB>` would shell-out. Verify the cache var name
    # is present so a refactor that drops caching is caught.
    grep -qE 'crate_cache_file|cargo_cache' "$compFile"
    assert $? equals 0
}

@test 'every _cargo helper fn name starts with _cargo or __cargo (namespace hygiene)' {
    # Pin: any fn that does NOT start with _cargo / __cargo would leak
    # into the user's namespace via autoload. Verify the file only
    # defines `_cargo*` / `__cargo*` fns at file scope.
    local stray
    stray=$(grep -nE '^[a-zA-Z][a-zA-Z0-9_]*\(\)' "$compFile" | grep -vE '^[0-9]+:_cargo|^[0-9]+:__cargo' || true)
    assert "$stray" is_empty
}

@test 'plugin file does NOT augment PATH (no PATH side effects)' {
    # Pin: cargo-completion's job is completion + aliases. PATH belongs
    # to the user, not the plugin. A PATH= assignment would be scope
    # creep. fpath= (for completion source dir) IS allowed.
    local matches
    matches=$(grep -E 'PATH=' "$pluginFile" | grep -vE 'fpath=' | wc -l | tr -d ' ')
    assert "$matches" same_as '0'
}
