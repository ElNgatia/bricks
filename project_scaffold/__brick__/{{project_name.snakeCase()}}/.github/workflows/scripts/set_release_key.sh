#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${KEYSTORE_FILE:-}" ]]; then
  echo "::error::KEYSTORE_FILE secret is required"
  exit 1
fi

if [[ -z "${KEYSTORE_PASSWORD:-}" || -z "${KEY_PASSWORD:-}" || -z "${KEY_ALIAS:-}" ]]; then
  echo "::error::KEYSTORE_PASSWORD, KEY_PASSWORD, and KEY_ALIAS secrets are required"
  exit 1
fi

echo "${KEYSTORE_FILE}" | base64 --decode > android/app/upload-keystore.jks
