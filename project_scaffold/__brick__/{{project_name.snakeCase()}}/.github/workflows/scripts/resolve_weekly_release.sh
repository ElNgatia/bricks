#!/usr/bin/env bash
set -euo pipefail

BUMP_INPUT="${BUMP_INPUT:-auto}"
FORCE="${FORCE:-false}"
OUTPUT_FILE="${GITHUB_OUTPUT:-/dev/stdout}"

PREVIOUS_TAG="$(git describe --tags --abbrev=0 --match 'v[0-9]*' 2>/dev/null || true)"
if [[ -z "${PREVIOUS_TAG}" ]]; then
  echo "::error::No previous v* release tag found to calculate the next version from"
  exit 1
fi

PREVIOUS_VERSION="${PREVIOUS_TAG#v}"
PREVIOUS_VERSION="${PREVIOUS_VERSION%%-*}"
if [[ ! "${PREVIOUS_VERSION}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "::error::Previous tag ${PREVIOUS_TAG} is not a v1.2.3 style tag"
  exit 1
fi
MAJOR="${BASH_REMATCH[1]}"
MINOR="${BASH_REMATCH[2]}"
PATCH="${BASH_REMATCH[3]}"

SUBJECTS="$(git log "${PREVIOUS_TAG}..HEAD" --no-merges --format='%s' | grep -v '^chore: bump version' || true)"
COMMIT_COUNT=0
if [[ -n "${SUBJECTS}" ]]; then
  COMMIT_COUNT="$(printf '%s\n' "${SUBJECTS}" | wc -l | tr -d ' ')"
fi

SHOULD_RELEASE=true
if [[ "${COMMIT_COUNT}" -eq 0 && "${FORCE}" != "true" ]]; then
  SHOULD_RELEASE=false
fi

BUMP="${BUMP_INPUT}"
if [[ "${BUMP}" == "auto" ]]; then
  if printf '%s\n' "${SUBJECTS}" | grep -Eq '^[a-z]+(\([^)]*\))?!:' ||
    git log "${PREVIOUS_TAG}..HEAD" --no-merges --format='%B' | grep -q '^BREAKING CHANGE'; then
    BUMP=major
  elif printf '%s\n' "${SUBJECTS}" | grep -Eq '^feat(\([^)]*\))?:'; then
    BUMP=minor
  else
    BUMP=patch
  fi
fi

case "${BUMP}" in
  major) NEXT_VERSION="$((MAJOR + 1)).0.0" ;;
  minor) NEXT_VERSION="${MAJOR}.$((MINOR + 1)).0" ;;
  patch) NEXT_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))" ;;
  *)
    echo "::error::bump must be auto, patch, minor or major. Got: ${BUMP}"
    exit 1
    ;;
esac

VERSION_LINE="$(grep -m1 '^version:' pubspec.yaml || true)"
if [[ ! "${VERSION_LINE}" =~ ^version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+([0-9]+)$ ]]; then
  echo "::error::pubspec.yaml version must look like x.y.z+build. Got: ${VERSION_LINE}"
  exit 1
fi
BUILD_NUMBER="$((BASH_REMATCH[1] + 1))"

{
  echo "should_release=${SHOULD_RELEASE}"
  echo "previous_tag=${PREVIOUS_TAG}"
  echo "version=${NEXT_VERSION}"
  echo "tag=v${NEXT_VERSION}"
  echo "build_number=${BUILD_NUMBER}"
  echo "bump=${BUMP}"
  echo "commit_count=${COMMIT_COUNT}"
} >> "${OUTPUT_FILE}"

echo "previous=${PREVIOUS_TAG} next=v${NEXT_VERSION}+${BUILD_NUMBER} bump=${BUMP} commits=${COMMIT_COUNT} release=${SHOULD_RELEASE}"
