FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    CONTAINER_TIMEZONE=America/Denver \
    DOMSERVER_BASEURL=http://domserver/ \
    JUDGEDAEMON_USERNAME=judgehost \
    JUDGEDAEMON_PASSWORD=password \
    DAEMON_ID=0 \
    DOMJUDGE_CREATE_WRITABLE_TEMP_DIR=0 \
    RUN_USER_UID_GID=62860

# Install required packages for running of judgehost
RUN apt update \
    && apt install --no-install-recommends --no-install-suggests -y \
    # Packages from the domjudge-packaging original
    dumb-init \
	acl lsof zip unzip supervisor sudo procps libcgroup1 \
	php-cli php-zip php-gd php-curl php-mysql php-json \
	php-gmp php-xml php-mbstring python3 \
	gcc g++ default-jre-headless default-jdk ghc fp-compiler \
    # Custom packages
    ruby nodejs mono-devel clang libicu-dev \
    # Step from domjudge-packageing original
    && rm -rf /var/lib/apt/lists/*

# Add chroot and judgehost data
ADD chroot.tar.gz /
ADD judgehost.tar.gz /
RUN cp /opt/domjudge/judgehost/etc/sudoers-domjudge /etc/sudoers.d/

# Add scripts
COPY judgehost/scripts /scripts/

# Make the scripts available to the root user
ENV PATH="$PATH:/opt/domjudge/judgehost/bin"

# Change start script permissions, add user and fix permissions
COPY judgehost/configure.sh /configure.sh
RUN chmod 700 /configure.sh && /configure.sh && rm -f /configure.sh

ENTRYPOINT ["/scripts/wait-for-it.sh", "domserver:80", "-t", "240", "--"]
CMD ["/scripts/start.sh"]
