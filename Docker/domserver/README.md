# Building a DOMServer Image

The process for building a domserver image is quite straightforward and managed by the `Dockerfile`
in this directory.

## Differences from the Default DOMjudge domserver Image

The DOMjudge project maintains its own
[domserver image on Docker Hub](https://hub.docker.com/r/domjudge/domserver/). The build process for
our domserver image is taken directly from their build process, but has the following changes:

*   The `wait-for-it.sh` script has been added. This script facilitates the use of the
    `docker-compose` command. By using this script as the entrypoint, the container wait to launch
    the domserver daemon until the database is reachable.
