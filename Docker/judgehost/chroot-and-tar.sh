#!/bin/bash

# Usage: https://github.com/DOMjudge/domjudge/blob/main/misc-tools/dj_make_chroot.in#L58-L87
# Customizations: Set distro to Ubuntu. Install additional languages.
/opt/domjudge/judgehost/bin/dj_make_chroot -D Ubuntu -i ruby,nodejs,mono-devel,mono-mcs,rustc

# Extract Swift into the chroot file system.
tar -xzf /swift.tar.gz --directory /chroot/domjudge/ --strip-components=1
rm /swift.tar.gz

cd /
echo "[..] Compressing chroot"
tar -czpf /chroot.tar.gz --exclude=/chroot/tmp --exclude=/chroot/proc --exclude=/chroot/sys --exclude=/chroot/mnt --exclude=/chroot/media --exclude=/chroot/dev --one-file-system /chroot
echo "[..] Compressing judge"
tar -czpf /judgehost.tar.gz /opt/domjudge/judgehost
