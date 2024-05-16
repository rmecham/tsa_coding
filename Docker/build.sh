#!/bin/bash -eu

# Start with a clean slate.
rm *.tar.gz

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
if ! wget --quiet "${URL}" -O ${FILE}
then
    echo "[!!] DOMjudge version ${DJ_VERSION} file not found on https://www.domjudge.org/releases"
    exit 1
fi
echo "[ok] DOMjudge version ${DJ_VERSION} downloaded as ${FILE}"; echo

NAMESPACE="tsacoding"
echo "[..] Building Docker image for domserver using intermediate build image..."
# docker build -t tsacoding/domserver:${BUILD} -t tsacoding/domserver:latest -f domserver/Dockerfile .
./build-domjudge.sh "${NAMESPACE}/domserver:${BUILD}"
echo "[ok] Done building Docker image for domserver"

# Download Swift package.
SWIFT_VERSION=$(<.swiftversion)
URL=https://swift.org/builds/swift-${SWIFT_VERSION}-release/ubuntu2204/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu22.04.tar.gz
FILE=swift.tar.gz
echo "[..] Downloading Swift version ${SWIFT_VERSION}"
if ! curl -f -s -o ${FILE} ${URL}; then
    echo "[!!] Swift version ${SWIFT_VERSION} could not be downloaded."
    exit 1
fi
echo "[ok] Swift version ${SWIFT_VERSION} downloaded as ${FILE}."; echo

echo "[..] Building Docker image for judgehost using intermediate build image..."
./build-judgehost.sh "${NAMESPACE}/judgehost:${BUILD}"
echo "[ok] Done building Docker image for judgehost"

echo "[..] Building Docker image for judgehost chroot..."
docker build -t "${NAMESPACE}/default-judgehost-chroot:${BUILD}" -f judgehost/Dockerfile.chroot .
echo "[ok] Done building Docker image for judgehost chroot"

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
else
    echo "To accept the build later on, perform the following:"
    echo "echo "$BUILD" > .lastbuild"
    echo "docker push tsacoding/domserver:${BUILD}"
    echo "docker push tsacoding/judgehost:${BUILD}"
    echo "docker push tsacoding/domserver:latest"
    echo "docker push tsacoding/judgehost:latest"
fi
