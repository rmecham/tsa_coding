#!/bin/sh -eu

cd /domjudge-src/domjudge*

# Overlay new commands.
cp /domserver-commands/* ./webapp/src/Command/
rm -rf /domserver-commands

# Overlay new executables.
/bin/cp -rf /defaultdata/* ./sql/files/defaultdata/
rm -rf /defaultdata

chown -R domjudge: .
# If we used a local source tarball, it might not have been built yet
sudo -u domjudge sh -c '. /venv/bin/activate && make dist'
sudo -u domjudge ./configure -with-baseurl=http://localhost/

# Passwords should not be included in the built image. We create empty files here to prevent passwords from being generated.
sudo -u domjudge touch etc/dbpasswords.secret etc/restapi.secret etc/symfony_app.secret etc/initial_admin_password.secret

sudo -u domjudge make domserver
make install-domserver

# Remove installed password files
rm /opt/domjudge/domserver/etc/*.secret

sudo -u domjudge sh -c '. /venv/bin/activate && make docs'
# Use Python venv to use the latest Sphinx to build DOMjudge docs.
# shellcheck source=/dev/null
. /venv/bin/activate
make install-docs
