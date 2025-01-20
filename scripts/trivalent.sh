#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh

dnf5 copr enable secureblue/trivalent
# Update the container and install packages
rpm-ostree update -y
grep -v '^#' ./trivalent.packages | xargs rpm-ostree install
