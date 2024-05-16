# High School Coding for the Technology Student Association (TSA)

This repository contains resources for running a high school Coding competition for the Technology
Student Association (TSA).

## Quick Start

### Step 1

Ensure that you have [Docker installed](https://www.docker.com/get-started) on the system you
plan to use to run DOMjudge.

### Step 2 (Linux Only)

If you are planning to run DOMjudge on Linux, you will need to ensure that `cgroups` are
enabled. (This is a feature of the Linux kernel that allows DOMjudge to execute submitted code in
an isolated environment for better security.) Instructions for doing so can be found
[in the DOMjudge documentation](https://www.domjudge.org/docs/manual/8.2/install-judgehost.html#linux-control-groups).

*If you are running Docker on macOS or Windows, you do not need to perform this step.*

### Step 3

Download the `docker-compose.yml` from this repository. If you have `wget` installed, you can
simply run:

```
wget https://raw.githubusercontent.com/rmecham/tsa_coding/master/docker-compose.yml
```

Otherwise, open [docker-compose.yml](https://raw.githubusercontent.com/rmecham/tsa_coding/master/docker-compose.yml)
in your browser and then choose File → Save As.

### Step 4

Download the environment file from this repository and rename it to `.env`. If you have `wget`
installed, you can simply run:

```
wget -O .env https://raw.githubusercontent.com/rmecham/tsa_coding/master/EXAMPLE-ENV
```

Otherwise, open [EXAMPLE-ENV](https://raw.githubusercontent.com/rmecham/tsa_coding/master/EXAMPLE-ENV)
in your browser and then choose File → Save As and use the filename `.env`. The environment file
must be named `.env` and must be in the same directory as the `docker-compose.yml` file.

*Once the file has been downloaded and renamed, you must edit it.* Wherever you see
`>>>CHANGE ME TO A PASSWORD<<<`, replace that text with an actual password. I recommend a
randomly-generated password of 30 characters. Sticking to a mix of uppercase letters, lowercase
letters, and numbers seems to work best. Also, be sure to set the time zone in which your
competition will take place.

### Step 5

Finally, run the following command wherever the `docker-compose.yml` file is:

```
docker-compose up
```

## Structure of This Repository

 *  **Docker** Resources for building new Docker images for the DOMjudge system. You will generally
    not need to use this directory.
