# GitHub Actions Workflows

This directory contains GitHub Actions workflows for automating the build and release process of the Hijacker app.

## Workflows

### 1. android-ci.yml - Continuous Integration

**Triggers:**
- Push to main, master, develop, or copilot/** branches
- Pull requests to main, master, or develop
- Manual trigger via workflow_dispatch

**Jobs:**
- **build**: Builds debug APK on every push/PR
- **build-release**: Builds and optionally signs release APK (only on main/master branch)

**Artifacts:**
- Debug APK (30 days retention)
- Release APK - unsigned or signed if secrets are configured (30-90 days retention)

### 2. release.yml - Build and Release

**Triggers:**
- Push of version tags (e.g., v2.0-android14)
- Manual trigger with custom version input

**Jobs:**
- Builds both debug and release APKs
- Signs release APK if secrets are configured
- Creates GitHub Release with all APKs
- Uploads artifacts with 90 days retention

## Setting Up Code Signing (Optional but Recommended)

To enable automatic APK signing for releases, add the following secrets to your repository:

1. Go to Settings → Secrets and variables → Actions
2. Add the following repository secrets:

   - `SIGNING_KEY`: Base64-encoded keystore file
   - `KEY_ALIAS`: Key alias from your keystore
   - `KEY_STORE_PASSWORD`: Keystore password
   - `KEY_PASSWORD`: Key password

### Generating the Signing Key Base64

```bash
# Create a keystore (if you don't have one)
keytool -genkey -v -keystore hijacker-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hijacker

# Convert to base64
base64 hijacker-release.jks | tr -d '\n' > signing_key_base64.txt

# Use the content of signing_key_base64.txt as the SIGNING_KEY secret
```

## Usage

### Building from CI

Simply push your code or create a PR. The CI workflow will automatically:
- Build debug APK
- Upload artifact for download

### Creating a Release

**Method 1: Using Git Tags (Recommended)**
```bash
# Create and push a version tag
git tag v2.0-android14
git push origin v2.0-android14
```

**Method 2: Manual Release**
1. Go to Actions → Build and Release
2. Click "Run workflow"
3. Enter version (e.g., v2.0-test)
4. Click "Run workflow"

### Downloading Built APKs

1. Go to the Actions tab
2. Click on the workflow run
3. Scroll down to "Artifacts"
4. Download the APK

## APK Types

- **Debug APK**: Built in debug mode with additional logging, unsigned
- **Release APK (Unsigned)**: Optimized release build, needs manual signing
- **Release APK (Signed)**: Optimized release build, signed and ready to install

## Troubleshooting

### Build Fails
- Check the workflow logs in the Actions tab
- Ensure all dependencies are properly declared in build.gradle
- Verify Gradle wrapper is committed

### Signing Fails
- Verify all signing secrets are correctly set
- Check that the keystore password and key alias match
- Ensure the base64 encoding is correct (no line breaks)

## Notes

- The workflows use Java 17 (required for AGP 8.x)
- Gradle caching is enabled for faster builds
- NDK components are automatically downloaded during build
- Build artifacts are retained for 30-90 days depending on type
