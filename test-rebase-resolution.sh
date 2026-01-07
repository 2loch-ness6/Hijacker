#!/bin/bash
# Test script to simulate and resolve the gradle.properties rebase conflict

set -e

echo "=== Gradle Properties Rebase Conflict Resolution Test ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create a temporary directory for testing
TEST_DIR="/tmp/rebase-conflict-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Initialize a git repo
git init
git config user.name "Test User"
git config user.email "test@example.com"

# Create initial gradle.properties with Kotlin properties
echo "Step 1: Creating initial gradle.properties with Kotlin properties..."
cat > gradle.properties << 'EOF'
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

# Kotlin configuration for future Kotlin migration
kotlin.code.style=official
EOF

git add gradle.properties
git commit -m "Initial commit with gradle.properties including Kotlin config"
echo -e "${GREEN}✓ Initial commit created${NC}"
echo ""

# Create the base branch (simulating copilot/remaster-app-for-aosp-14)
echo "Step 2: Creating base branch (target for rebase)..."
git checkout -b base-branch

# Remove Kotlin properties in base branch
cat > gradle.properties << 'EOF'
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
EOF

git add gradle.properties
git commit -m "Remove Kotlin properties from gradle.properties"
echo -e "${GREEN}✓ Base branch created with clean gradle.properties${NC}"
echo ""

# Go back to master and create a feature branch
echo "Step 3: Creating feature branch with conflicting changes..."
git checkout master
git checkout -b feature-branch

# Make different changes to gradle.properties
cat > gradle.properties << 'EOF'
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

# Kotlin configuration
kotlin.code.style=official
kotlin.incremental=true
EOF

git add gradle.properties
git commit -m "Fix PR review comments: thread pool, race conditions, PendingIntent flags, and critical notification channel bug"
echo -e "${GREEN}✓ Feature branch created with additional Kotlin properties${NC}"
echo ""

# Try to rebase onto base-branch (this should cause a conflict)
echo "Step 4: Attempting rebase (expecting conflict)..."
echo -e "${YELLOW}Running: git rebase base-branch${NC}"
if git rebase base-branch 2>&1; then
    echo -e "${RED}✗ Expected a conflict but rebase succeeded${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Conflict occurred as expected${NC}"
    echo ""
    
    # Show the conflict
    echo "Step 5: Showing the conflict in gradle.properties..."
    echo "----------------------------------------"
    cat gradle.properties || true
    echo "----------------------------------------"
    echo ""
    
    # Resolve the conflict
    echo "Step 6: Resolving the conflict..."
    cat > gradle.properties << 'EOF'
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
EOF
    
    echo -e "${GREEN}✓ Conflict resolved - Kotlin properties removed, AndroidX and buildconfig kept${NC}"
    echo ""
    
    # Mark as resolved and continue rebase
    echo "Step 7: Marking file as resolved..."
    git add gradle.properties
    echo -e "${GREEN}✓ File marked as resolved${NC}"
    echo ""
    
    echo "Step 8: Continuing rebase..."
    if git rebase --continue; then
        echo -e "${GREEN}✓ Rebase completed successfully${NC}"
        echo ""
        
        # Verify the final result
        echo "Step 9: Verifying final gradle.properties content..."
        echo "----------------------------------------"
        cat gradle.properties
        echo "----------------------------------------"
        echo ""
        
        # Check for conflict markers
        if grep -q "<<<<<<" gradle.properties || grep -q ">>>>>>" gradle.properties || grep -q "======" gradle.properties; then
            echo -e "${RED}✗ FAIL: Conflict markers still present!${NC}"
            exit 1
        else
            echo -e "${GREEN}✓ No conflict markers found${NC}"
        fi
        
        # Check for required lines
        if grep -q "android.useAndroidX=true" gradle.properties && \
           grep -q "android.defaults.buildfeatures.buildconfig=true" gradle.properties; then
            echo -e "${GREEN}✓ Required AndroidX and buildconfig lines present${NC}"
        else
            echo -e "${RED}✗ FAIL: Required lines missing!${NC}"
            exit 1
        fi
        
        # Check that Kotlin properties are removed
        if grep -q "kotlin." gradle.properties; then
            echo -e "${RED}✗ FAIL: Kotlin properties should be removed!${NC}"
            exit 1
        else
            echo -e "${GREEN}✓ Kotlin properties removed as expected${NC}"
        fi
        
        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}✓ ALL TESTS PASSED!${NC}"
        echo -e "${GREEN}Rebase conflict resolved successfully!${NC}"
        echo -e "${GREEN}========================================${NC}"
    else
        echo -e "${RED}✗ Rebase continuation failed${NC}"
        exit 1
    fi
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"
echo ""
echo "Test directory cleaned up."
