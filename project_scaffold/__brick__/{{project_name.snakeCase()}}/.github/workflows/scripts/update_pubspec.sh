#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${APP_VERSION:-}" || -z "${BUILD_NUMBER:-}" ]]; then
  echo "::error::APP_VERSION and BUILD_NUMBER are required"
  exit 1
fi

if [[ ! "${APP_VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "::error::APP_VERSION must look like x.y.z. Got: ${APP_VERSION}"
  exit 1
fi

if [[ ! "${BUILD_NUMBER}" =~ ^[0-9]+$ ]]; then
  echo "::error::BUILD_NUMBER must be numeric. Got: ${BUILD_NUMBER}"
  exit 1
fi

tmp_file="$(mktemp)"
awk -v version="${APP_VERSION}+${BUILD_NUMBER}" '
  /^version:[[:space:]]*/ && !updated {
    print "version: " version
    updated = 1
    next
  }
  { print }
  END {
    if (!updated) {
      exit 42
    }
  }
' pubspec.yaml > "${tmp_file}" || {
  status=$?
  rm -f "${tmp_file}"
  if [[ "${status}" -eq 42 ]]; then
    echo "::error::No version field found in pubspec.yaml"
  fi
  exit "${status}"
}

mv "${tmp_file}" pubspec.yaml
echo "Updated pubspec.yaml to version: ${APP_VERSION}+${BUILD_NUMBER}"
