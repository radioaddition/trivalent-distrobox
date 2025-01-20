#!/bin/sh

./distrobox-shims.sh
wget https://copr.fedorainfracloud.org/coprs/secureblue/trivalent/repo/fedora-41/secureblue-trivalent-fedora-41.repo -o /etc/yum.repos.d/
rpm-ostree refresh-md
rpm-ostree update
grep -v '^#' ./trivalent.packages | xargs rpm-ostree install -y
