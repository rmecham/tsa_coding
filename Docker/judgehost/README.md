# Building a JudgeHost Image

The judgehost is the component of the DOMjudge system that actually compiles (if needed), executes,
and evaluates code submitted for judging. As such, it must have the build tools installed for any
programming language allowed in a given competition.

Additionally, the judgehost uses a particular UNIX feature known as
[chroot](https://en.wikipedia.org/wiki/Chroot). The idea is to isolate the execution of contestant
code into a sandboxed environment for added security. Accordingly, the build tools for each
supported programming language mentioned above must be installed in the `chroot` environment.

Frustratingly, the judgehost seems to perform any compilation and/or preflight checks *outside* of
the `chroot` environment but the actual execution happens *inside* the `chroot` environment. That
means that for most, if not all, programming languages, the build tools must be installed both
inside *and* outside the chroot. This significantly increases the size of the resulting image.

## The Build Process

Building the judgehost involves using an intermediary container. The intermediary container is
managed by `build.Dockerfile`. It is responsible for compiling the judgehost portion of the DOMjudge
codebase and for creating the `chroot` environment via `chroot-and-tar.sh` (which itself uses the
dj_make_chroot script from the DOMjudge codebase). The intermediary container is not uploaded to
Docker Hub and is discarded during the build process.

The compiled DOMjudge code and `chroot` environment are then copied into the final container. This
container is managed by `Dockerfile` and is the container that is uploaded to Docker Hub.

## Adding a Supported Programming Language

If the language is available via the normal Debian/Ubuntu `apt install` command (most but not all
programming languages are), then the process is relatively straightforward:

1.  Add the relevant apt package names to the `dj_make_chroot` command inside the
    `chroot-and-tar.sh` script. This will add the language to the `chroot` environment.
2.  Add the relevant apt package names to the `apt-get install` section of the `Dockerfile`. This
    will add the language to the judgehost image outside of the `chroot` environment.

## Differences from the Default DOMjudge jugdehost Image

The DOMjudge project maintains its own
[judgehost image on Docker Hub](https://hub.docker.com/r/domjudge/judgehost/). The build process for
our judgehost image is taken directly from their build process, but has the following changes:

*   The `wait-for-it.sh` script has been added. This script facilitates the use of the
    `docker-compose` command. By using this script as the entrypoint, the container wait to launch
    the judgehost daemon until the domserver is reachable.
*   Support for the [Ruby](https://www.ruby-lang.org/en/) programming language has been added.
