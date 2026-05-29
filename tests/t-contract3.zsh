#!/usr/bin/env zunit
#{{{                    MARK:Header
##### Purpose: zsh-cargo-completion — third-tier surface pins covering:
#####          - state machine balance in _cargo (case/esac pairing)
#####          - state dispatch branches match the cargo subcommands
#####          - cache function uses _retrieve_cache + _store_cache pair
#####          - alias `cfa` chain has 3 stages separated by semicolons
#####          - `co` alias is bare `cargo` (NO arguments tail)
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    pluginFile="$pluginDir/zsh-cargo-completion.plugin.zsh"
    compFile="$pluginDir/src/_cargo"
}

@test 'case/esac balance in _cargo (every case has a matching esac)' {
    # Pin: an unbalanced case/esac silently truncates state-machine
    # dispatch. Count must match exactly.
    local cases esacs
    cases=$(grep -cE '^[[:space:]]*case ' "$compFile")
    esacs=$(grep -cE '^[[:space:]]*esac[[:space:]]*$' "$compFile")
    assert "$cases" same_as "$esacs"
}

@test 'state machine dispatches on $state (the _arguments convention)' {
    # Pin: zsh _arguments populates $state with the active state name.
    # The dispatch case MUST be `case $state in` exactly. A typo like
    # `case state in` (literal) would silently match nothing.
    grep -qE '^[[:space:]]*case \$state in[[:space:]]*$' "$compFile"
    assert $? equals 0
}

@test 'cache fn pairs _retrieve_cache with _store_cache (the compsys cache contract)' {
    # Pin: compsys caching requires both halves — retrieve to check
    # for hit, store to populate on miss. Either alone is a bug:
    # store-only never reads, retrieve-only never warms.
    local retrieve store
    retrieve=$(grep -c '_retrieve_cache' "$compFile")
    store=$(grep -c '_store_cache' "$compFile")
    [[ "$retrieve" -ge 1 && "$store" -ge 1 ]]
    assert $state equals 0
}

@test 'cfa alias is the 3-stage polish chain (fix; clippy --fix; fmt)' {
    # Pin: cfa is a deliberate 3-step sequence — `fix`, then
    # `clippy --all-targets --fix -- -D warnings`, then `fmt`.
    # Removing any stage silently changes lint discipline.
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile' 2>/dev/null
        alias cfa
    ")
    [[ "$body" == *'cargo fix'* && "$body" == *'cargo clippy'* && "$body" == *'cargo fmt'* ]]
    assert $state equals 0
}

@test 'co alias is bare cargo (NO trailing subcommand)' {
    # Pin: co is the catchall short form. Aliasing it to `cargo build`
    # or `cargo run` would silently break `co --version`, `co --help`,
    # etc. Body MUST equal exactly `cargo`.
    local body
    body=$(zsh -c "
        emulate zsh
        source '$pluginFile' 2>/dev/null
        alias co
    ")
    assert "$body" same_as "co=cargo"
}
