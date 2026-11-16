#!/usr/bin/env bash
set -euo pipefail

KERNEL_DIR="${1:?Usage: $0 <path-to-kernel-source> <base-config-path>}"
BASE_CONFIG="${2:?Usage: $0 <path-to-kernel-source> <base-config-path>}"

cd "$KERNEL_DIR"

# Start from the installed Ubuntu 26.04 generic/lowlatency config
cp "$BASE_CONFIG" .config

# Enable Lockdep and core lock debugging options
./scripts/config --enable CONFIG_DEBUG_KERNEL
./scripts/config --enable CONFIG_DEBUG_LOCK_ALLOC
./scripts/config --enable CONFIG_PROVE_LOCKING
./scripts/config --enable CONFIG_LOCKDEP
./scripts/config --enable CONFIG_DEBUG_SPINLOCK
./scripts/config --enable CONFIG_DEBUG_MUTEXES
./scripts/config --enable CONFIG_DEBUG_RWSEMS
./scripts/config --enable CONFIG_DEBUG_ATOMIC_SLEEP

# Disable Canonical private signing keys and debuginfo bloat so build fits in runner disk
./scripts/config --set-str CONFIG_SYSTEM_TRUSTED_KEYS ""
./scripts/config --set-str CONFIG_SYSTEM_REVOCATION_KEYS ""
./scripts/config --disable CONFIG_MODULE_SIG
./scripts/config --disable CONFIG_DEBUG_INFO_BTF

# Disable ZFS / conflicting CDDL module checks triggered by lockdep
./scripts/config --disable CONFIG_ZFS || true

# Workaround for Ubuntu 7.0.0-43 broken klp-checksum.c backport (LP: #2173273)
sed -i 's/BUILD_KLP := y/BUILD_KLP := n/' tools/objtool/Makefile

# Resolve any newly exposed sub-dependencies non-interactively
make olddefconfig
