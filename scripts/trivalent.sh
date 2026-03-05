#!/bin/sh

curl https://copr.fedorainfracloud.org/coprs/secureblue/hardened_malloc/repo/fedora-$(rpm -E %fedora)/secureblue-hardened_malloc-fedora-$(rpm -E %fedora).repo -o /etc/yum.repos.d/secureblue-hardened_malloc-fedora-$(rpm -E %fedora).repo
curl https://copr.fedorainfracloud.org/coprs/secureblue/packages/repo/fedora-$(rpm -E %fedora)/secureblue-packages-fedora-$(rpm -E %fedora).repo -o /etc/yum.repos.d/secureblue-packages-fedora-$(rpm -E %fedora).repo
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf makecache --refresh
dnf update
grep -v '^#' ./trivalent.packages | xargs dnf install -y
