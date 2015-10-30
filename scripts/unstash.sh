#!/bin/sh

CARTHAGE_BINARY_DIR="Carthage/Build"
IOS_BINARY_DIR="${CARTHAGE_BINARY_DIR}/iOS"
IOS_ZIP="iOS.zip"

rm -rf "${IOS_BINARY_DIR}"
mkdir -p "${IOS_BINARY_DIR}"
curl -L https://www.googledrive.com/host/0B--nGoDU083Ma3hTMFNPVUlvbzA > "${IOS_BINARY_DIR}/${IOS_ZIP}"
cd "${IOS_BINARY_DIR}"
unzip "${IOS_ZIP}"
rm -f "${IOS_ZIP}"
