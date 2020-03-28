# Using Docker to Run DOMjudge

## Prerequisites

Before you can begin, you must first install two critical software packages on the system on which
you intend to run DOMjudge. The first is [git](https://git-scm.com) and the second is
[Docker](https://www.docker.com). Both are available for Mac, Windows, and Linux and both provide
detailed installation instructions.

## Build and Run Process

With git installed, you can clone this repository to the machine that will run DOMjudge.

Then, from this directory, run the following commands:

```
docker-compose build
docker-compose run
```

The first command will take quite a while the first time it is run. Once the second command launches,
you should be able to point a browser to http://localhost:5000/ and see the DOMjudge system.
