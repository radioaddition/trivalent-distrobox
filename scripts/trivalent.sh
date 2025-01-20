#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh

#./copr.sh enable secureblue/trivalent
# Update the container and install packages
rpm-ostree update
rpm-ostree --enablerepo secureblue/trivalent
grep -v '^#' ./trivalent.packages | xargs rpm-ostree install -y
