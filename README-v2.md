# Hijacker - Android 14 Modernization

## 🚀 What's New in v2.0

This major update modernizes Hijacker for **Android 14** (API 34) with support for modern AOSP devices, particularly **OxygenOS 14** on 2023-24 flagship Qualcomm chipsets.

### Key Improvements

#### ✅ Android 14 Compatibility
- **Target SDK 34** - Full Android 14 support
- **Minimum SDK 26** - Android 8.0+ required
- **Modern Build System** - Gradle 8.5 + AGP 8.2.2
- **Updated Permissions** - Android 13+ notification and WiFi permissions
- **Scoped Storage** - Modern storage access patterns
- **Foreground Service Types** - Compliant with Android 14 requirements

#### 📦 Updated Dependencies
- AndroidX AppCompat 1.6.1
- Material Design Components 1.11.0
- AndroidX Core 1.12.0
- AndroidX Fragment 1.6.2
- AndroidX Lifecycle 2.7.0
- AndroidX Preferences 1.2.1
- Latest NDK 26.1.10909125

#### 🏗️ Build System Improvements
- Modern Gradle 8.5 with Kotlin DSL support
- Automated CI/CD with GitHub Actions
- Optimized build configuration
- Parallel builds enabled
- R8 full mode optimization
- ARM64-v8a primary target (64-bit optimized)

#### 🔧 Code Modernization
- Modern AsyncTask replacement (ExecutorService-based)
- Fixed AGP 8.x compatibility issues
- Updated deprecated API usage
- Enhanced error handling
- Improved lifecycle management

#### 🔐 Enhanced Permissions
```xml
<!-- Android 13+ -->
- POST_NOTIFICATIONS
- NEARBY_WIFI_DEVICES
- READ_MEDIA_* (Images, Video, Audio)

<!-- WiFi & Network -->
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- CHANGE_NETWORK_STATE

<!-- Storage -->
- MANAGE_EXTERNAL_STORAGE
```

#### ⚡ Performance Optimizations
- ARM64-only builds for modern devices
- Optimized for Snapdragon 8 Gen 2/3
- Reduced APK size
- Faster startup times
- Memory optimizations

### 🤖 CI/CD Integration

Automated builds via GitHub Actions:
- **Debug APK** - Built on every push
- **Release APK** - Built for releases (with optional signing)
- **Artifacts** - Available for 30-90 days
- **GitHub Releases** - Automated release creation

See [`.github/workflows/README.md`](.github/workflows/README.md) for details.

## 📋 Requirements

### Minimum Requirements
- **Android 8.0+** (API 26+)
- **ARM64 device** (64-bit processor)
- **Root access** (su binary required)
- **WiFi adapter** with monitor mode support

### Recommended Setup
- **Android 14** on flagship 2023-24 device
- **Qualcomm Snapdragon** 8 Gen 2/3 chipset
- **OxygenOS 14** or similar AOSP-based ROM
- **Kali NetHunter** for enhanced wireless capabilities
- **6GB+ RAM** for optimal performance

### Supported Chipsets (with NetHunter)
- Snapdragon 8 Gen 3 (SM8650)
- Snapdragon 8 Gen 2 (SM8550)
- Snapdragon 8+ Gen 1 (SM8475)
- Snapdragon 8 Gen 1 (SM8450)
- Other Qualcomm chipsets with monitor mode support

## 🚀 Installation

### Method 1: From Releases (Recommended)
1. Go to [Releases](../../releases)
2. Download the latest APK
   - **Signed Release**: Ready to install (recommended)
   - **Unsigned Release**: Requires manual signing
   - **Debug**: For testing with logs
3. Enable "Install from Unknown Sources"
4. Install the APK
5. Grant all requested permissions

### Method 2: Build from Source
```bash
# Clone the repository
git clone https://github.com/2loch-ness6/Hijacker.git
cd Hijacker

# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# APKs will be in app/build/outputs/apk/
```

## 🛠️ Development

### Prerequisites
- Android Studio Hedgehog (2023.1.1) or newer
- JDK 17
- Android SDK 34
- NDK 26.1.10909125
- Git

### Building
```bash
# Debug build
./gradlew assembleDebug

# Release build
./gradlew assembleRelease

# Clean build
./gradlew clean assembleDebug

# Install on connected device
./gradlew installDebug
```

### Running Tests
```bash
# Unit tests
./gradlew test

# Instrumented tests (requires device)
./gradlew connectedAndroidTest
```

## 🔍 Troubleshooting

### Common Issues

#### "SU binary not found!"
- Ensure device is rooted
- Verify su binary is in PATH
- Try a different root solution (Magisk recommended)

#### "No root access"
- Grant root permission when prompted
- Check root manager app (SuperSU/Magisk)
- Verify Hijacker is authorized

#### Permissions Issues (Android 13+)
- Go to Settings → Apps → Hijacker
- Grant all requested permissions:
  - Notifications
  - Location (Fine & Coarse)
  - Nearby Devices
  - Storage/Media
  - Special: Manage All Files

#### Monitor Mode Not Working
- Verify chipset supports monitor mode
- Install Kali NetHunter (recommended)
- Check adapter supports monitor mode
- Configure monitor mode commands in settings

#### Build Failures
- Update Android Studio
- Sync Gradle files
- Clean build: `./gradlew clean`
- Clear Gradle cache: `rm -rf ~/.gradle/caches/`
- Ensure JDK 17 is installed

## 📱 Compatibility

### Tested Devices
- OnePlus 11 (OxygenOS 14 - Snapdragon 8 Gen 2)
- Samsung Galaxy S23 (OneUI 6 - Snapdragon 8 Gen 2)
- Google Pixel 8 Pro (Android 14 - Tensor G3)
- Xiaomi 13 Pro (MIUI 14 - Snapdragon 8 Gen 2)

### Known Working Chipsets (with NetHunter)
- Qualcomm Snapdragon 8 series (Gen 1-3)
- Qualcomm Snapdragon 888/888+
- Qualcomm Snapdragon 865/865+

### Known Issues
- Some Exynos/MediaTek devices may not support monitor mode
- Stock ROMs may have limited functionality
- Some OEM skins restrict root capabilities

## 🔐 Security Notes

### Permissions Explained
- **Root**: Required for wireless tools (aircrack-ng, mdk3, reaver)
- **Location**: Required by Android for WiFi scanning (API 29+)
- **Notifications**: For background operation alerts
- **Nearby Devices**: Required for WiFi operations (Android 13+)
- **Storage**: For saving capture files and wordlists

### Best Practices
- Only use on networks you own or have permission to test
- Keep app updated for security patches
- Use strong root management (Magisk recommended)
- Review permissions regularly
- Use NetHunter for enhanced security

## 📝 Changelog

### v2.0-android14 (2026-01-07)
- ✅ Modernized for Android 14 (API 34)
- ✅ Updated to Gradle 8.5 + AGP 8.2.2
- ✅ Migrated to modern AndroidX libraries
- ✅ Added Android 13+ permission support
- ✅ Optimized for ARM64 devices
- ✅ Added GitHub Actions CI/CD
- ✅ Fixed deprecated API usage
- ✅ Enhanced for OxygenOS 14
- ✅ Support for 2023-24 flagship chipsets
- ✅ Improved build performance
- ✅ Updated documentation

### v1.7 (Previous)
- ARM64 support
- WearOS compatibility
- Various bug fixes

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the GNU General Public License v3.0.

See [COPYING](COPYING) for details.

## ⚠️ Legal Disclaimer

This software is provided for educational and security auditing purposes only. 

**You are responsible for:**
- Ensuring you have permission to test any network
- Complying with all applicable laws and regulations
- Any damages or legal consequences from misuse

**Illegal use is prohibited and may result in:**
- Criminal prosecution
- Civil liability
- Network bans
- Device seizure

Use responsibly and ethically.

## 🙏 Credits

- Original Author: [chrisk44](https://github.com/chrisk44)
- ARM64 Port: [yesimxev](https://github.com/yesimxev)
- Android 14 Modernization: This fork
- Tools: Aircrack-ng, MDK3, Reaver, Wireless Tools
- Framework: Kali NetHunter

## 📧 Support

- **Issues**: [GitHub Issues](../../issues)
- **Wiki**: [GitHub Wiki](../../wiki)
- **Original Project**: [chrisk44/Hijacker](https://github.com/chrisk44/Hijacker)

---

**Remember**: Use this tool responsibly and only on networks you own or have explicit permission to test.
