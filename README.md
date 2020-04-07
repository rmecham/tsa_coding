# High School Coding for the Technology Student Association (TSA)

This repository contains resources for running a high school Coding competition for the Technology
Student Association (TSA).

## Quick Start

First, ensure that you have [Docker installed](https://www.docker.com/get-started) on the system you
plan to use to run DOMjudge.

Next, if you are planning to run DOMjudge on Linux, you will need to ensure that `cgroups` are
enabled. (This is a feature of the Linux kernel that allows DOMjudge to execute submitted code in
an isolated environment for better security.) Instructions for doing so can be found
[in the DOMjudge documentation](https://www.domjudge.org/docs/manual/install-judgehost.html#linux-control-groups).
*If you are running Docker on macOS or Windows, you do not need to perform this step.*

Next, download the `docker-compose.yml` from this repository. If you have `wget` installed, you can
simply run:

```
wget https://raw.githubusercontent.com/rmecham/tsa_coding/master/docker-compose.yml
```

Otherwise, open [docker-compose.yml](https://raw.githubusercontent.com/rmecham/tsa_coding/master/docker-compose.yml)
in your browser and then choose File → Save As.

Finally, run the following command wherever the `docker-compose.yml` file is:

```
docker-compose up
```

## Structure of This Repository

 *  **Docker** Resources for building new Docker images for the DOMjudge system. You will generally
    not need to use this directory.
