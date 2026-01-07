# Migration Guide: v1.7 → v2.0 (Android 14)

## Overview

This guide helps users and developers migrate from Hijacker v1.7 to v2.0 with Android 14 support.

## For Users

### What's Changed

#### Minimum Android Version
- **Before**: Android 5.0 (API 21)
- **After**: Android 8.0 (API 26)

If you're on Android 5-7, you must stay on v1.7 or upgrade your device.

#### Device Architecture
- **Before**: ARMv7 (32-bit) and ARM64 (64-bit)
- **After**: ARM64 (64-bit) only

Modern flagship devices (2020+) are all 64-bit, so this shouldn't affect most users.

#### New Permissions Required

When upgrading, you'll need to grant new permissions:

1. **Notification Permission** (Android 13+)
   - Required for background operation alerts
   - Settings → Apps → Hijacker → Notifications → Allow

2. **Nearby WiFi Devices** (Android 13+)
   - Required for WiFi scanning without location
   - Settings → Apps → Hijacker → Nearby devices → Allow

3. **Precise Location**
   - Now required by Android for WiFi scanning
   - Settings → Apps → Hijacker → Location → Precise location

4. **Manage All Files** (Recommended)
   - For better storage access
   - Settings → Apps → Hijacker → Special access → All files access

### Installation Steps

1. **Backup Your Data**
   ```
   - Export custom actions (Settings → Custom Actions → Export)
   - Note your monitor mode commands (Settings → write them down)
   - Backup capture files from /sdcard/Hijacker/
   ```

2. **Uninstall Old Version** (Recommended)
   ```
   - This ensures clean installation
   - Your data in /sdcard/Hijacker/ will be preserved
   ```

3. **Install v2.0**
   ```
   - Download from Releases
   - Install APK
   - Grant all permissions when prompted
   ```

4. **Restore Settings**
   ```
   - Re-enter monitor mode commands if needed
   - Import custom actions if exported
   - Verify tool tests pass (Settings → Test Tools)
   ```

### What Still Works

✅ All existing features
✅ Custom actions (need re-import)
✅ Monitor mode commands (need re-entry)
✅ Capture files (in same location)
✅ Wordlists (in same location)
✅ NetHunter integration

### What's Improved

✅ Better performance on modern devices
✅ Improved stability on Android 13+
✅ Better permission handling
✅ More reliable background operation
✅ Enhanced NetHunter support

## For Developers

### Build System Changes

#### Gradle Version
```gradle
// Before
gradle-6.1.1

// After
gradle-8.5
```

#### Android Gradle Plugin
```gradle
// Before
classpath 'com.android.tools.build:gradle:3.6.1'

// After
classpath 'com.android.tools.build:gradle:8.2.2'
```

#### Repositories
```gradle
// Before
repositories {
    google()
    jcenter()  // Deprecated!
}

// After
repositories {
    google()
    mavenCentral()
}
```

### SDK Versions

```gradle
// Before
android {
    compileSdkVersion 29
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 29
    }
}

// After
android {
    namespace 'com.hijacker'
    compileSdk 34
    defaultConfig {
        minSdkVersion 26
        targetSdkVersion 34
    }
}
```

### Dependencies

```gradle
// Before
implementation 'androidx.appcompat:appcompat:1.1.0'
implementation 'com.google.android.material:material:1.1.0'

// After
implementation 'androidx.appcompat:appcompat:1.6.1'
implementation 'com.google.android.material:material:1.11.0'
implementation 'androidx.core:core:1.12.0'
implementation 'androidx.fragment:fragment:1.6.2'
implementation 'androidx.lifecycle:lifecycle-runtime:2.7.0'
implementation 'androidx.preference:preference:1.2.1'
```

### Code Changes Required

#### 1. R Class Constants (Critical!)

**Problem**: In AGP 8.x, R class fields are no longer compile-time constants.

**Before**:
```java
switch(item.getItemId()) {
    case R.id.action_settings:
        // ...
        break;
    case R.id.action_about:
        // ...
        break;
}
```

**After**:
```java
int itemId = item.getItemId();
if(itemId == R.id.action_settings) {
    // ...
} else if(itemId == R.id.action_about) {
    // ...
}
```

#### 2. AsyncTask Replacement

**Problem**: AsyncTask is deprecated in Android 11+.

**Before**:
```java
class MyTask extends AsyncTask<Void, String, Boolean> {
    @Override
    protected Boolean doInBackground(Void... params) {
        // Background work
        return true;
    }
    
    @Override
    protected void onPostExecute(Boolean result) {
        // Update UI
    }
}

new MyTask().execute();
```

**After** (Option 1 - Use ModernAsyncTask helper):
```java
class MyTask extends ModernAsyncTask<Void, String, Boolean> {
    @Override
    protected Boolean doInBackground(Void... params) {
        // Background work
        return true;
    }
    
    @Override
    protected void onPostExecute(Boolean result) {
        // Update UI
    }
}

new MyTask().execute();
```

**After** (Option 2 - ExecutorService):
```java
ExecutorService executor = Executors.newSingleThreadExecutor();
Handler handler = new Handler(Looper.getMainLooper());

executor.execute(() -> {
    // Background work
    Boolean result = doWork();
    
    handler.post(() -> {
        // Update UI with result
    });
});
```

#### 3. Package Declaration

**Before** (AndroidManifest.xml):
```xml
<manifest package="com.hijacker">
```

**After** (build.gradle):
```gradle
android {
    namespace 'com.hijacker'
}
```

Remove `package` attribute from AndroidManifest.xml.

#### 4. BuildConfig

**Before**: Automatically available

**After**: Must enable explicitly
```gradle
android {
    buildFeatures {
        buildConfig true
    }
}
```

### Manifest Changes

#### New Permissions
```xml
<!-- Android 13+ -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES"
    android:usesPermissionFlags="neverForLocation" />

<!-- Location (required for WiFi scanning) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Modern storage -->
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

#### Foreground Service Type
```xml
<!-- Before -->
<service
    android:name=".PersistenceService"
    android:enabled="true"
    android:exported="false" />

<!-- After -->
<service
    android:name=".PersistenceService"
    android:enabled="true"
    android:exported="false"
    android:foregroundServiceType="specialUse">
    <property
        android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE"
        android:value="wifi_monitoring" />
</service>
```

#### Activity Export
```xml
<!-- Activities with intent-filters must be exported -->
<activity
    android:name=".MainActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>
```

### NDK Changes

```gradle
// Before
android {
    ndkVersion = '21.0.6113669'
    defaultConfig {
        ndk {
            abiFilters 'arm64-v8a', 'armeabi-v7a'
        }
    }
}

// After
android {
    ndkVersion = '26.1.10909125'
    defaultConfig {
        ndk {
            abiFilters 'arm64-v8a'  // 64-bit only
        }
    }
}
```

### Java Version

```gradle
// Add this to android block
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
```

### Testing Changes

```gradle
// Before
testImplementation 'junit:junit:4.12'
androidTestImplementation 'androidx.test.espresso:espresso-core:3.1.0'

// After
testImplementation 'junit:junit:4.13.2'
androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
```

### Common Build Issues

#### Issue: "R cannot be resolved"
**Solution**: Clean and rebuild
```bash
./gradlew clean
./gradlew assembleDebug
```

#### Issue: "Namespace not specified"
**Solution**: Add to build.gradle
```gradle
android {
    namespace 'com.hijacker'
}
```

#### Issue: "Case expressions must be constant"
**Solution**: Convert switch to if-else (see above)

#### Issue: "The option 'android.enableJetifier' is deprecated"
**Solution**: This is just a warning, safe to ignore if using AndroidX

#### Issue: "Execution failed for task ':app:mergeDebugNativeLibs'"
**Solution**: 
```bash
rm -rf .cxx
./gradlew clean
./gradlew assembleDebug
```

### Gradle Properties

Add/update these in `gradle.properties`:
```properties
# Modern Android
android.useAndroidX=true
android.enableJetifier=true
android.nonTransitiveRClass=true
android.nonFinalResIds=true

# Performance
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m

# R8 optimization
android.enableR8.fullMode=true
```

## Migration Checklist

### For Users
- [ ] Backup custom actions
- [ ] Backup monitor mode commands
- [ ] Verify device is ARM64
- [ ] Verify Android 8.0+
- [ ] Uninstall old version
- [ ] Install new version
- [ ] Grant all permissions
- [ ] Test tools (Settings → Test Tools)
- [ ] Restore custom actions
- [ ] Re-enter monitor mode commands

### For Developers
- [ ] Update Gradle to 8.5
- [ ] Update AGP to 8.2.2
- [ ] Update compileSdk to 34
- [ ] Update targetSdk to 34
- [ ] Update minSdk to 26
- [ ] Add namespace declaration
- [ ] Replace jcenter() with mavenCentral()
- [ ] Convert switch statements for R class
- [ ] Replace AsyncTask usage
- [ ] Update permissions in manifest
- [ ] Add foreground service type
- [ ] Update NDK version
- [ ] Remove ARMv7 support
- [ ] Update dependencies
- [ ] Test on Android 14 device
- [ ] Update CI/CD (GitHub Actions)

## Support

If you encounter issues during migration:
1. Check this guide thoroughly
2. Search [GitHub Issues](../../issues)
3. Create a new issue with:
   - Android version
   - Device model
   - Error logs
   - Steps to reproduce

## Additional Resources

- [Android 14 Migration Guide](https://developer.android.com/about/versions/14/migration)
- [AGP 8.x Migration](https://developer.android.com/build/releases/past-releases/agp-8-0-0-release-notes)
- [Gradle 8.x Release Notes](https://docs.gradle.org/8.5/release-notes.html)
