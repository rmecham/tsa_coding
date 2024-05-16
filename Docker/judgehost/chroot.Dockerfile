FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt -y install \
  ca-certificates default-jre-headless pypy3 locales \
  && rm -rf /var/lib/apt/lists/*

RUN chmod a-s \
  /usr/bin/wall \
  /usr/bin/newgrp \
  /usr/bin/chage \
  /usr/bin/chfn \
  /usr/bin/chsh \
  /usr/bin/expiry \
  /usr/bin/gpasswd \
  /usr/bin/passwd \
  /bin/su \
  /bin/mount \
  /bin/umount \
  /sbin/unix_chkpwd \
  || true
