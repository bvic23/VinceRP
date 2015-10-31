#!/bin/sh

CARTHAGE_BINARY_DIR="Carthage/Build"
CARTHAGE_ZIP="Carthage.zip"

rm -rf "${CARTHAGE_BINARY_DIR}"
mkdir -p "${CARTHAGE_BINARY_DIR}"
curl -L https://www.googledrive.com/host/0B--nGoDU083MUGoyenBlajFIOUk > "${CARTHAGE_BINARY_DIR}/${CARTHAGE_ZIP}"
cd "${CARTHAGE_BINARY_DIR}"
unzip "${CARTHAGE_ZIP}"
rm -f "${CARTHAGE_ZIP}"
