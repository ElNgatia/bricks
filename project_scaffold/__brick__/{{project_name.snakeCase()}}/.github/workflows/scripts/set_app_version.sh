#!/usr/bin/env bash
set -euo pipefail

TAG_NAME="${TAG_NAME:-}"

if [[ -z "${TAG_NAME}" ]]; then
  echo "::error::TAG_NAME is required"
  exit 1
fi

APP_VERSION="${TAG_NAME#v}"
APP_VERSION="${APP_VERSION%%-*}"

if [[ ! "${APP_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::Release tag must look like v1.2.3, v1.2.3-rc.1, or v1.2.3-hotfix.1. Got: ${TAG_NAME}"
  exit 1
fi

CURRENT_VERSION_LINE="$(grep -m1 '^version:' pubspec.yaml || true)"
if [[ ! "${CURRENT_VERSION_LINE}" =~ ^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+([0-9]+)$ ]]; then
  echo "::error::pubspec.yaml version must look like x.y.z+build. Got: ${CURRENT_VERSION_LINE}"
  exit 1
fi

CURRENT_BUILD_NUMBER="${BASH_REMATCH[1]}"
BUILD_NUMBER="$((CURRENT_BUILD_NUMBER + 1))"

{
  echo "APP_VERSION=${APP_VERSION}"
  echo "BUILD_NUMBER=${BUILD_NUMBER}"
} >> "${GITHUB_OUTPUT}"

echo "Resolved APP_VERSION=${APP_VERSION}"
echo "Resolved BUILD_NUMBER=${BUILD_NUMBER}"
