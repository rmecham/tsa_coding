# Building Docker Images

## Introduction

If you are looking to simply run the DOMjudge system for your competition, *this is not the place
for you*. This directory contains the tools and files needed to build new versions of the Docker
images.

## Perform a Build

If performing a new build is indeed what you are looking to do, then the good news is that the
process is highly automated. Assuming you have [Docker](https://www.docker.com) installed already,
and assuming that you are running a UNIX-based operating environment (e.g.
[Linux](https://www.techradar.com/best/best-linux-distros), [macOS](https://www.apple.com/macos/),
or [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)), all
you need to do is this:

```
./build.sh
```

The build process will take several minutes to complete. This process builds both a
[domserver](https://hub.docker.com/repository/docker/tsacoding/domserver) (the web front end) and a
[judgehost](https://hub.docker.com/repository/docker/tsacoding/judgehost) (the system that actually
evaluates the contestants’ code) image. At the end of the build process, the script will prompt you
to upload the build to Docker Hub. In order for the upload to work, you must already be logged into
Docker Hub via the [docker login](https://docs.docker.com/engine/reference/commandline/login/)
command.
