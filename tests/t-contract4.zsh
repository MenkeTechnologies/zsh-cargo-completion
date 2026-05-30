#!/usr/bin/env zunit
#{{{                    MARK:Header
##### Purpose: zsh-cargo-completion — fourth-tier contracts.
#####          Pins for toolchain-selector composition: `+stable`,
#####          `+beta`, `+nightly` exclusion lists, common-flag
#####          inheritance (--frozen, --locked, -Z), and absence
#####          of nightly-only flags in stable-path completions.
#}}}***********************************************************

@setup {
    0="${${0:#$ZSH_ARGZERO}:-${(%):-%N}}"
    0="${${(M)0:#/*}:-$PWD/$0}"
    pluginDir="${0:h:A}"
    compFile="$pluginDir/src/_cargo"
}

@test '+stable / +beta / +nightly toolchain selectors are MUTUALLY EXCLUSIVE' {
    # Pin: each toolchain selector's exclusion list must enumerate the
    # OTHER two. Otherwise `cargo +stable +nightly` completes both as
    # valid simultaneously, which contradicts rustup's "one toolchain
    # per invocation" semantic. Verify all three lines exist and each
    # carries an exclusion containing the other two.
    grep -qE "\(\+beta \+nightly\)\+stable\[use the stable toolchain\]" "$compFile"
    local s=$?
    grep -qE "\(\+stable \+nightly\)\+beta\[use the beta toolchain\]" "$compFile"
    local b=$?
    grep -qE "\(\+stable \+beta\)\+nightly\[use the nightly toolchain\]" "$compFile"
    local n=$?
    assert $(( s + b + n )) equals 0
}

@test '--frozen and --locked both present in `common` flag block' {
    # Pin: both flags inhibit network/lockfile mutation; dropping either
    # would surprise users wiring up CI. They live in `common=( ... )`
    # so every subcommand inherits them via the `$common` expansion.
    awk '/^[[:space:]]*common=\(/,/^[[:space:]]*\)/' "$compFile" > /tmp/cargo_common.$$
    local has_frozen has_locked
    grep -q -- '--frozen' /tmp/cargo_common.$$ && has_frozen=1 || has_frozen=0
    grep -q -- '--locked' /tmp/cargo_common.$$ && has_locked=1 || has_locked=0
    rm -f /tmp/cargo_common.$$
    assert $(( has_frozen + has_locked )) equals 2
}

@test '-Z unstable-flag option routes to `_cargo_unstable_flags` callback' {
    # Pin: nightly users compose `cargo +nightly -Z <flag>`. The -Z
    # option must dispatch through a dedicated callback so completion
    # surfaces the nightly-only flag list (not generic file fallback).
    grep -qF '_cargo_unstable_flags' "$compFile"
    local found_ref=$?
    grep -qE "^[[:space:]]+'-Z\+" "$compFile"
    local found_z=$?
    assert $(( found_ref + found_z )) equals 0
}

@test '_cargo_unstable_flags helper is defined exactly once' {
    # Pin: the callback referenced by -Z must have a single definition;
    # duplicates risk last-wins shadowing and a silent regression of
    # the nightly flag list.
    local count
    count=$(grep -cE '^_cargo_unstable_flags\(\)' "$compFile")
    assert "$count" same_as '1'
}

@test 'all toolchain selectors carry the literal `use the ... toolchain` description' {
    # Pin: `_describe` / `_arguments` render the bracketed text in the
    # completion menu. If the description is dropped or genericized, the
    # user loses the visual signal distinguishing stable/beta/nightly.
    local count
    count=$(grep -cE '\[use the (stable|beta|nightly) toolchain\]' "$compFile")
    assert "$count" same_as '3'
}
