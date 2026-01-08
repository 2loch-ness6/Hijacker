# Git Rebase Conflict Resolution Guide

## Issue Description
When pushing/rebasing to `copilot/remaster-app-for-aosp-14`, a merge conflict occurs in `gradle.properties` file with the error:
```
CONFLICT (content): Merge conflict in gradle.properties
error: could not apply f285f90... Fix PR review comments: thread pool, race conditions, PendingIntent flags, and critical notification channel bug
```

## Root Cause
The conflict occurred because:
1. The commit `f285f90` removed Kotlin-related properties from `gradle.properties`
2. The target branch `copilot/remaster-app-for-aosp-14` (commit dbfc137) already had a clean version
3. Git couldn't automatically merge the changes

## Solution Steps

### Step 1: Identify the Conflict
When the rebase fails with a conflict message, check the status:
```bash
git status
```

You'll see:
```
rebase in progress; onto dbfc137
You are currently rebasing branch 'copilot/remaster-app-for-aosp-14' on 'dbfc137'.
  (fix conflicts and then run "git rebase --continue")

Unmerged paths:
  (use "git add <file>..." to mark resolution)
        both modified:   gradle.properties
```

### Step 2: Examine the Conflict
View the conflicted file:
```bash
cat gradle.properties
```

The file will contain conflict markers like:
```
<<<<<<< HEAD
# Some version of the content
=======
# Another version of the content
>>>>>>> f285f90... Fix PR review comments
```

### Step 3: Resolve the Conflict
The correct resolved content for `gradle.properties` should be:

```properties
# Project-wide Gradle settings.

# IDE (e.g. Android Studio) users:
# Gradle settings configured through the IDE *will override*
# any settings specified in this file.

# For more details on how to configure your build environment visit
# http://www.gradle.org/docs/current/userguide/build_environment.html

# Specifies the JVM arguments used for the daemon process.
# The setting is particularly useful for tweaking memory settings.
android.enableJetifier=true
android.useAndroidX=true
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m

# Enable parallel builds and caching
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true

# Android build optimizations
android.enableR8.fullMode=true
android.nonTransitiveRClass=true
android.nonFinalResIds=true

# Use AndroidX namespace
android.defaults.buildfeatures.buildconfig=true
```

**Key points:**
- Keep all AndroidX configuration lines
- Keep the `android.defaults.buildfeatures.buildconfig=true` line
- Remove any Kotlin-related properties (kotlin.code.style, etc.)
- Remove ALL conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
- Ensure proper file formatting with no trailing whitespace issues

### Step 4: Mark as Resolved
After editing the file to remove conflict markers and keep only the correct content:
```bash
git add gradle.properties
```

### Step 5: Continue the Rebase
```bash
git rebase --continue
```

If there are no more conflicts, this will complete the rebase.

### Step 6: Push the Changes
```bash
git push origin copilot/remaster-app-for-aosp-14
```

## Verification
After pushing, verify the file content:
```bash
git show HEAD:gradle.properties
```

Ensure it matches the correct content above without any:
- Merge conflict markers
- Kotlin properties (unless Kotlin plugin is added)
- Duplicate or conflicting configurations

## Prevention
To avoid similar conflicts in the future:
1. Always fetch and rebase on the latest target branch before creating PRs
2. Keep gradle.properties synchronized across branches
3. Remove unused configuration properties promptly
4. Coordinate with team members when modifying build configuration files

## References
- Original issue: Rebase conflict during push to copilot/remaster-app-for-aosp-14
- Affected commit: f285f90
- Target branch: copilot/remaster-app-for-aosp-14 (dbfc137)
- Reference commit: 9864ae00231f76698a5c00ac889bd3fffbd8fd3b
