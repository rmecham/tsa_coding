#!/bin/bash -e

# Establish build number.
LAST_BUILD=$(<.lastbuild)
TIMESTAMP="$(date "+%Y%m")"
if [ "${LAST_BUILD:0:6}" == "$TIMESTAMP" ]; then
    next_build="$((${LAST_BUILD:7:15} + 1))"
    BUILD="${TIMESTAMP}.${next_build}"
else
    BUILD="${TIMESTAMP}.1"
fi
echo "[..] Initiating build ${BUILD}."

# Download DOMjudge package.
DJ_VERSION=$(<.djversion)
URL=https://www.domjudge.org/releases/domjudge-${DJ_VERSION}.tar.gz
FILE=domjudge.tar.gz
echo "[..] Downloading DOMJuge version ${DJ_VERSION}..."
if ! curl -f -s -o ${FILE} ${URL}
then
    echo "[!!] DOMjudge version ${DJ_VERSION} file not found on https://www.domjudge.org/releases"
    exit 1
fi
echo "[ok] DOMjudge version ${DJ_VERSION} downloaded as domjudge.tar.gz"; echo

echo "[..] Building Docker image for domserver using intermediate build image..."
docker build -t tsacoding/domserver:${BUILD} -t tsacoding/domserver:latest -f domserver/Dockerfile .
echo "[ok] Done building Docker image for domserver"

echo "[..] Building Docker image for judgehost using intermediate build image..."
docker build -t tsacoding/judgehost:${BUILD}-build -f judgehost/build.Dockerfile .
docker rm -f tsacoding-judgehost-${BUILD}-build > /dev/null 2>&1 || true
docker run -it --name tsacoding-judgehost-${BUILD}-build --privileged tsacoding/judgehost:${BUILD}-build
docker cp tsacoding-judgehost-${BUILD}-build:/chroot.tar.gz .
docker cp tsacoding-judgehost-${BUILD}-build:/judgehost.tar.gz .
docker rm -f tsacoding-judgehost-${BUILD}-build
docker rmi tsacoding/judgehost:${BUILD}-build
docker build -t tsacoding/judgehost:${BUILD} -t tsacoding/judgehost:latest -f judgehost/Dockerfile .
echo "[ok] Done building Docker image for judgehost"

read -p "Accept these builds and push to Docker Hub? " -n 1 -r
echo  # Advance a line.
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Write out the build ID.
    echo "$BUILD" > .lastbuild
    # Push the images to Docker Hub.
    docker push tsacoding/domserver:${BUILD}
    docker push tsacoding/judgehost:${BUILD}
    docker push tsacoding/domserver:latest
    docker push tsacoding/judgehost:latest
fi
