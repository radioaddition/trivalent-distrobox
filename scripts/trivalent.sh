#!/bin/sh

curl https://repo.secureblue.dev/secureblue.repo -o /etc/yum.repos.d/secureblue.repo
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf makecache --refresh
dnf update
grep -v '^#' ./trivalent.packages | xargs dnf install -y
