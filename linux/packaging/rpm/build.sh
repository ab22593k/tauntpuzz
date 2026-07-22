#!/usr/bin/env bash
set -euo pipefail

# Builds leafz as an RPM package.
#
# fastforge 0.6.9 has a bug in its RPM maker — this script does it correctly.
#
# Usage:
#   ./linux/packaging/rpm/build.sh

NAME="leafz"
VERSION="1.1.0"
SUMMARY="organiq puzzle where the pieces hum a forgotten melody"
LICENSE="MIT"
VENDOR="maintainer"
PACKAGER="Abdulwahab <ab22593K@gmail.com>"
URL="https://github.com/ab22593k/leafz"
ICON="assets/app-icon-with-dash-ltr.png"

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
DIST="$ROOT/dist"
RPMBUILD="$DIST/rpmbuild"
SPECS_DIR="$RPMBUILD/SPECS"
RPMS_DIR="$RPMBUILD/RPMS/x86_64"

# ---- 1. Build the Flutter Linux bundle ----
echo "==> Building Flutter Linux release bundle..."
cd "$ROOT"
flutter build linux --release
BUNDLE="build/linux/x64/release/bundle"

# Fix plugin .so rpaths (absolute paths from the build machine → $ORIGIN)
echo "==> Fixing plugin rpaths..."
for so in "$BUNDLE/lib/"*.so; do
  rpath=$(patchelf --print-rpath "$so" 2>/dev/null || true)
  if echo "$rpath" | grep -q "/home"; then
    patchelf --set-rpath '$ORIGIN' "$so"
  fi
done

# ---- 2. Create source tarball ----
echo "==> Creating source tarball..."
mkdir -p "$RPMBUILD/SOURCES"
PKG_DIR="$RPMBUILD/_pkg"
rm -rf "$PKG_DIR"
SRC_DIR="$PKG_DIR/${NAME}-${VERSION}"
mkdir -p "$SRC_DIR/$NAME"
cp -r "$BUNDLE/leafz" "$SRC_DIR/$NAME/"
cp -r "$BUNDLE/data"  "$SRC_DIR/$NAME/"
cp -r "$BUNDLE/lib"   "$SRC_DIR/$NAME/"

cat > "$SRC_DIR/${NAME}.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Leafz
GenericName=Musical Puzzle Game
Icon=${NAME}
Exec=${NAME} %U
Categories=Game;
Keywords=Puzzle;Game;
StartupNotify=true
DESKTOP

if [ -f "$ROOT/$ICON" ]; then
  cp "$ROOT/$ICON" "$SRC_DIR/${NAME}.png"
fi

cd "$PKG_DIR"
tar czf "$RPMBUILD/SOURCES/${NAME}-${VERSION}.tar.gz" "${NAME}-${VERSION}"
cd "$ROOT"
rm -rf "$PKG_DIR"

# ---- 3. Write the spec file ----
echo "==> Writing spec..."
mkdir -p "$SPECS_DIR"
mkdir -p "$RPMS_DIR"

cat > "$SPECS_DIR/${NAME}.spec" <<SPEC
%global debug_package %{nil}

Name: $NAME
Version: $VERSION
Release: 1%{?dist}
Summary: $SUMMARY
Group: Applications/Games
Vendor: $VENDOR
Packager: $PACKAGER
License: $LICENSE
URL: $URL
BuildArch: x86_64
Source0: ${NAME}-${VERSION}.tar.gz

%description
$SUMMARY

%prep
%setup -q

%build
# pre-compiled — nothing to build

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/pixmaps
cp -r %{name}/* %{buildroot}%{_datadir}/%{name}
ln -s %{_datadir}/%{name}/%{name} %{buildroot}%{_bindir}/%{name}
cp %{name}.desktop %{buildroot}%{_datadir}/applications/
cp %{name}.png %{buildroot}%{_datadir}/pixmaps/

%files
%defattr(-,root,root)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%attr(4755, root, root) %{_datadir}/pixmaps/%{name}.png
SPEC

# ---- 4. Build the RPM ----
echo "==> Running rpmbuild..."
QA_RPATHS=$(( 0x0001 | 0x0002 | 0x0010 )) \
rpmbuild --define "_topdir $RPMBUILD" -bb "$SPECS_DIR/${NAME}.spec"

# ---- 5. Copy result ----
echo "==> Copying RPM to dist/..."
mkdir -p "$DIST"
find "$RPMS_DIR" -name "*.rpm" -exec cp {} "$DIST/" \;

echo "==> Done! RPM(s) in $DIST/"
ls -lh "$DIST"/*.rpm 2>/dev/null || echo "(no RPMs found)"
