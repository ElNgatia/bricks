# Publishing {{project_name.titleCase()}}

Releases go out through GitHub Actions. fastlane lives in `ios/fastlane/`.

| Workflow | Trigger | Does |
|---|---|---|
| `ci.yml` | push / PR | slang, build_runner, analyze, test |
| `conventional-release-labels.yaml` | PR | labels PRs from their conventional-commit title, for release notes |
| `weekly-release.yaml` | Saturday 15:07 UTC, or manual | works out the next version from commits since the last `v*` tag, creates the GitHub release and dispatches the App Store publish |
| `publish-playstore.yml` | GitHub release published | builds the AAB and APK, uploads to the Play Store production track, then opens a PR bumping `pubspec.yaml` and `CHANGELOG.md` |
| `appstore-publish.yaml` | manual, or dispatched by the weekly release | builds and signs the IPA, uploads it to TestFlight and, with `publish_listing`, submits it for review |

## Before the first release

- **Change the bundle id.** Both stores reject `com.example.*`, and neither lets
  the id change after the first upload. Android's is `applicationId` in
  `android/app/build.gradle.kts`, iOS's is `PRODUCT_BUNDLE_IDENTIFIER` in
  `ios/Runner.xcodeproj`. The workflows read both from there.
- **Create the store records.** The Play Console app and the App Store Connect
  app have to exist, and the first Play Store upload has to be made by hand.
- **Tag a starting point.** The weekly release counts from the latest `v1.2.3`
  tag, so create one (for example `v1.0.0`) on the commit of your first release.
- **Merge each version bump PR** before the next release. The weekly release
  stops while one is open, since the build number would repeat and the stores
  reject repeated build numbers.

## Secrets

Android (`publish-playstore.yml`):

| Secret | Value |
|---|---|
| `KEYSTORE_FILE` | upload keystore, base64 encoded (`base64 -w0 upload-keystore.jks`) |
| `KEYSTORE_PASSWORD` | keystore password |
| `KEY_ALIAS` | key alias |
| `KEY_PASSWORD` | key password |
| `SERVICE_ACCOUNT_JSON` | Play Console service account JSON with release permissions |

iOS (`appstore-publish.yaml`):

| Secret | Value |
|---|---|
| `IOS_CERTIFICATE_BASE64` | Apple Distribution certificate `.p12`, base64 encoded |
| `IOS_CERTIFICATE_PASSWORD` | `.p12` password |
| `IOS_PROVISIONING_PROFILE_BASE64` | App Store provisioning profile, base64 encoded |
| `KEYCHAIN_PASSWORD` | any value, used for the temporary CI keychain |
| `IOS_TEAM_ID` | Apple Developer Team ID |
| `APPSTORE_ISSUER_ID` | App Store Connect API issuer id |
| `APPSTORE_KEY_ID` | App Store Connect API key id |
| `APPSTORE_PRIVATE_KEY` | contents of the `AuthKey_XXXX.p8` file |
| `APPSTORE_DEMO_USER` | sign-in for App Review, if the app needs an account |
| `APPSTORE_DEMO_PASSWORD` | password for that account |

Repository variables (not secrets) for the App Review contact, required by
`publish_listing`: `APPSTORE_CONTACT_FIRST_NAME`, `APPSTORE_CONTACT_LAST_NAME`,
`APPSTORE_CONTACT_EMAIL`, `APPSTORE_CONTACT_PHONE`, and optionally
`APPSTORE_REVIEW_NOTES`.

Weekly release:

| Secret | Value |
|---|---|
| `RELEASE_PAT` | a token with `contents` and `actions` write. A release created with the default `GITHUB_TOKEN` does not trigger other workflows, so the Play Store publish would never start. |

## Signing locally

`bin/configure_release.dart` (run once by the scaffold) points the Android
release build at `android/key.properties`:

```properties
storeFile=upload-keystore.jks
storePassword=...
keyAlias=...
keyPassword=...
```

Without it, release builds fall back to the debug key. `key.properties` and
`*.jks` are gitignored.

It also sets `ITSAppUsesNonExemptEncryption` to `false` in
`ios/Runner/Info.plist`, which answers App Store export compliance for apps
that only use standard HTTPS. Change it if the app ships its own encryption.

## Store listing

`deliver` uploads `ios/fastlane/metadata/` and `ios/fastlane/screenshots/`
once they exist, and leaves the current App Store listing alone until then.
`fastlane deliver download_metadata` and `download_screenshots` seed them from
App Store Connect.

Local lanes, from `ios/` with the `ASC_*` and `APPLE_TEAM_ID` variables set
(see the top of `ios/fastlane/Fastfile`): `fastlane ios beta`,
`fastlane ios metadata`, `fastlane ios release`.
