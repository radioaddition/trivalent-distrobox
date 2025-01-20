#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh

./copr.sh enable secureblue/trivalent
rpm-ostree refresh-md
rpm-ostree update
grep -v '^#' ./trivalent.packages | xargs rpm-ostree install -y
