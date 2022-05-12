#!/bin/bash
set -euxo pipefail

BASEDIR=$(dirname "$0")
OUTPUT=$1
CODESIGN_IDENTITY=${CODESIGN_IDENTITY:-mock}
PRODUCTSIGN_IDENTITY=${PRODUCTSIGN_IDENTITY:-mock}
NO_CODESIGN=${NO_CODESIGN:-0}

function sign() {
  if [ "${NO_CODESIGN}" -eq "1" ]; then
    return
  fi
  local opts=""
  entitlements="${BASEDIR}/$(basename "$1").entitlements"
  if [ -f "${entitlements}" ]; then
      opts="--entitlements ${entitlements}"
  fi
  codesign --deep --sign "${CODESIGN_IDENTITY}" --options runtime --force ${opts} "$1"
}

binDir="${BASEDIR}/root/tmp-podman-desktop"

version=$(cat "${BASEDIR}/VERSION")

sign "${binDir}/podman"

pkgbuild --identifier com.redhat.podman --version ${version} \
  --scripts "${BASEDIR}/scripts" \
  --root "${BASEDIR}/root" \
  --install-location /tmp \
  --component-plist "${BASEDIR}/component.plist" \
  "${OUTPUT}/podman.pkg"

productbuild --distribution "${BASEDIR}/Distribution" \
  --resources "${BASEDIR}/Resources" \
  --package-path "${OUTPUT}" \
  "${OUTPUT}/podman-unsigned.pkg"
rm "${OUTPUT}/podman.pkg"

if [ ! "${NO_CODESIGN}" -eq "1" ]; then
  productsign --sign "${PRODUCTSIGN_IDENTITY}" "${OUTPUT}/podman-unsigned.pkg" "${OUTPUT}/podman-desktop-macos.pkg"
else
  mv "${OUTPUT}/podman-unsigned.pkg" "${OUTPUT}/podman-desktop-macos.pkg"
fi
