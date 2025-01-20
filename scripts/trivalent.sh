#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh

ostree remote add metalink=https://copr.fedorainfracloud.org/coprs/secureblue/trivalent/repo/fedora-41/secureblue-trivalent-fedora-41.repo
rpm-ostree --enablerepo=trivalent refresh-md
rpm-ostree update
grep -v '^#' ./trivalent.packages | xargs rpm-ostree install -y
