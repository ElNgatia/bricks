#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${APP_VERSION:-}" || -z "${BUILD_NUMBER:-}" ]]; then
  echo "::error::APP_VERSION and BUILD_NUMBER are required"
  exit 1
fi

CHANGELOG_FILE="CHANGELOG.md"
RELEASE_TAG="${RELEASE_TAG:-v${APP_VERSION}}"
RELEASE_DATE="$(date -u +%Y-%m-%d)"
NOTES="${RELEASE_BODY:-No release notes provided.}"

entry_file="$(mktemp)"
{
  echo "## [${RELEASE_TAG}] - ${RELEASE_DATE}"
  echo
  echo "${NOTES}"
  echo
} > "${entry_file}"

if [[ ! -f "${CHANGELOG_FILE}" ]]; then
  { echo "# Changelog"; echo; cat "${entry_file}"; } > "${CHANGELOG_FILE}"
else
  tmp_file="$(mktemp)"
  {
    sed -n '1,2p' "${CHANGELOG_FILE}"
    cat "${entry_file}"
    sed -n '3,$p' "${CHANGELOG_FILE}"
  } > "${tmp_file}"
  mv "${tmp_file}" "${CHANGELOG_FILE}"
fi

rm -f "${entry_file}"
echo "Updated ${CHANGELOG_FILE} with entry for ${RELEASE_TAG}"
