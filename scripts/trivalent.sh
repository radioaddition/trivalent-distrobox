#!/bin/sh

curl https://copr.fedorainfracloud.org/coprs/secureblue/hardened_malloc/repo/fedora-41/secureblue-hardened_malloc-fedora-41.repo -o /etc/yum.repos.d/secureblue-hardened_malloc-fedora-41.repo
curl https://copr.fedorainfracloud.org/coprs/secureblue/trivalent/repo/fedora-41/secureblue-trivalent-fedora-41.repo -o /etc/yum.repos.d/secureblue-trivalent-fedora-41.repo
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf refresh-md
dnf update
grep -v '^#' ./trivalent.packages | xargs dnf install -y
