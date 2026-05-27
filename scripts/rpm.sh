#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Paths
PROJECT_ROOT="$(pwd)"
PUBSPEC="$PROJECT_ROOT/pubspec.yaml"
FLUTTER_BUNDLE="$PROJECT_ROOT/build/linux/x64/release/bundle"
BUILD_DIR="$PROJECT_ROOT/build/rpm_workspace"
RPMROOT="$BUILD_DIR/rpmbuild"

echo "🔎 Parsing configuration from pubspec.yaml..."

if [ ! -f "$PUBSPEC" ]; then
    echo "❌ Error: pubspec.yaml not found in the current working directory."
    exit 1
fi

APP_NAME=$(grep '^name:' "$PUBSPEC" | head -n1 | sed 's/name://g' | tr -d '[:space:]')
RAW_VERSION=$(grep '^version:' "$PUBSPEC" | head -n1 | sed 's/version://g' | tr -d '[:space:]')
VERSION=$(echo "$RAW_VERSION" | cut -d'+' -f1)
RELEASE=$(echo "$RAW_VERSION" | cut -d'+' -f2 -s)

if [ -z "$RELEASE" ]; then
    RELEASE="1"
fi

SUMMARY="Flutter application: $APP_NAME"
LICENSE="MIT"
URL="https://example.com"
DESCRIPTION="A beautiful native desktop application built with Flutter for Fedora."

echo "----------------------------------------"
echo "📦 App Name:    $APP_NAME"
echo "🏷️  Version:     $VERSION"
echo "🔢 Release:     $RELEASE"
echo "----------------------------------------"

if [ ! -d "$FLUTTER_BUNDLE" ]; then
    echo "❌ Error: Flutter release bundle not found at $FLUTTER_BUNDLE"
    echo "Please run 'flutter build linux --release' first."
    exit 1
fi

# Ensure required tooling is installed (Adding patchelf to fix RPATHs)
for cmd in rpmbuild rpmdev-setuptree tar patchelf; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ Error: '$cmd' is not installed. Run: sudo dnf install rpmdevtools patchelf"
        exit 1
    fi
done

echo "🧹 Setting up isolated build environment..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$RPMROOT"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo "📦 Creating source archive..."
ARCHIVE_NAME="${APP_NAME}-${VERSION}"
TARGET_SOURCE_DIR="$BUILD_DIR/$ARCHIVE_NAME"

cp -r "$FLUTTER_BUNDLE" "$TARGET_SOURCE_DIR"

cat <<EOF > "$BUILD_DIR/$APP_NAME.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_NAME^}
Comment=$SUMMARY
Exec=/usr/bin/$APP_NAME
Icon=/usr/lib/$APP_NAME/data/flutter_assets/assets/icon.png
Terminal=false
Categories=Utility;
EOF

cd "$BUILD_DIR"
tar -czf "$RPMROOT/SOURCES/$ARCHIVE_NAME.tar.gz" "$ARCHIVE_NAME"
cp "$APP_NAME.desktop" "$RPMROOT/SOURCES/"
cd "$PROJECT_ROOT"

echo "📝 Generating RPM Spec file..."
cat <<EOF > "$RPMROOT/SPECS/$APP_NAME.spec"
Name:           $APP_NAME
Version:        $VERSION
Release:        $RELEASE%{?dist}
Summary:        $SUMMARY

License:        $LICENSE
URL:            $URL
Source0:        %{name}-%{version}.tar.gz
Source1:        %{name}.desktop

Requires:       gtk3, glib2

%global debug_package %{nil}

%description
$DESCRIPTION

%prep
%setup -q

%install
rm -rf %{buildroot}

mkdir -p %{buildroot}/usr/lib/%{name}
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications

cp -r * %{buildroot}/usr/lib/%{name}/
cp %{SOURCE1} %{buildroot}/usr/share/applications/
ln -s /usr/lib/%{name}/%{name} %{buildroot}/usr/bin/%{name}

# --- FIX RPATH ISSUES ---
# Loop over all shared libraries and force their runpath to look inside the app package folder
find %{buildroot}/usr/lib/%{name}/ -name "*.so" -type f | while read -r lib; do
    patchelf --set-rpath '\$ORIGIN' "\$lib"
done
# Also sanitize the primary app binary runpath
patchelf --set-rpath '\$ORIGIN/lib' %{buildroot}/usr/lib/%{name}/%{name}

%files
/usr/bin/%{name}
/usr/lib/%{name}/
/usr/share/applications/%{name}.desktop

%changelog
* $(date "+%a %b %d %Y") Flutter Packager Script <auto@package.internal> - ${VERSION}-${RELEASE}
- Fixed hardcoded local development RPATH validation failures via patchelf
EOF

echo "🏗️ Building RPM package..."
# QA_RPATHS=0x0002 tells rpmbuild to allow overrides of invalid development paths
QA_RPATHS=$(( 0x0002 )) rpmbuild --define "_topdir $RPMROOT" -ba "$RPMROOT/SPECS/$APP_NAME.spec"

FINAL_RPM=$(find "$RPMROOT/RPMS" -type f -name "*.rpm")
echo "=================================================="
echo "✅ Success! RPM generated successfully."
echo "📍 Location: $FINAL_RPM"
echo "🚀 To install locally, run:"
echo "   sudo dnf install $FINAL_RPM"
echo "=================================================="
