#!/bin/bash -e

VERSION=$1
if [[ -z ${VERSION} ]]
then
    echo "Usage: $0 domjudge-version"
    echo "	For example: $0 5.3.0"
    exit 1
fi

URL=https://www.domjudge.org/releases/domjudge-${VERSION}.tar.gz
FILE=domjudge.tar.gz

echo "[..] Downloading DOMJuge version ${VERSION}..."

if ! curl -f -s -o ${FILE} ${URL}
then
    echo "[!!] DOMjudge version ${VERSION} file not found on https://www.domjudge.org/releases"
    exit 1
fi

echo "[ok] DOMjudge version ${VERSION} downloaded as domjudge.tar.gz"; echo

echo "[..] Building Docker image for domserver using intermediate build image..."
docker build -t tsacoding/domserver:${VERSION} -f domserver/Dockerfile .
echo "[ok] Done building Docker image for domserver"

echo "[..] Building Docker image for judgehost using intermediate build image..."
docker build -t tsacoding/judgehost:${VERSION}-build -f judgehost/build.Dockerfile .
docker rm -f tsacoding-judgehost-${VERSION}-build > /dev/null 2>&1 || true
docker run -it --name tsacoding-judgehost-${VERSION}-build --privileged tsacoding/judgehost:${VERSION}-build
docker cp tsacoding-judgehost-${VERSION}-build:/chroot.tar.gz .
docker cp tsacoding-judgehost-${VERSION}-build:/judgehost.tar.gz .
docker rm -f tsacoding-judgehost-${VERSION}-build
docker rmi tsacoding/judgehost:${VERSION}-build
docker build -t tsacoding/judgehost:${VERSION} -f judgehost/Dockerfile .
echo "[ok] Done building Docker image for judgehost"

echo "[..] Building Docker image for judgehost chroot..."
# docker build -t tsacoding/default-judgehost-chroot:${VERSION} -f judgehost/Dockerfile.chroot .
echo "[ok] Done building Docker image for judgehost chroot"

echo "All done. Image tsacoding/domserver:${VERSION} and tsacoding/judgehost:${VERSION} created"
echo "If you are a DOMjudge maintainer with access to the tsacoding organization on Docker Hub, you can now run the following command to push them to Docker Hub:"
echo "$ docker push tsacoding/domserver:${VERSION} && docker push tsacoding/judgehost:${VERSION} && docker push tsacoding/default-judgehost-chroot:${VERSION}"
echo "If this is the latest release, also run the following command:"
echo "$ docker tag tsacoding/domserver:${VERSION} tsacoding/domserver:latest && \
docker tag tsacoding/judgehost:${VERSION} tsacoding/judgehost:latest && \
docker tag tsacoding/default-judgehost-chroot:${VERSION} tsacoding/default-judgehost-chroot:latest && \
docker push tsacoding/domserver:latest && docker push tsacoding/judgehost:latest && docker push tsacoding/default-judgehost-chroot:latest"
