#!/bin/bash

# This script handles version replacement and package creation

set -e

# Get the version from config.json
VERSION=$(grep -o '"version": "[^"]*' config.json | grep -o '[^"]*$')
echo "🎮 Packaging v$VERSION"

# Verify required tools
if ! command -v c1541 &> /dev/null; then
    echo "❌ Error: c1541 (from VICE) is required but not found"
    exit 1
fi

# Build the C64 project with version injection
echo "🔨 Building C64 BASIC project..."

# Temporarily inject version for build
sed -i.bak "s/###VERSION###/$VERSION/g" "c64/src/main.bas"

# Use Python compiler to rebuild (from VS64 extension)
PYTHON_EXE="$HOME/.vscode/extensions/rosc.vs64-2.6.2/resources/python/python.exe"
BC_EXE="$HOME/.vscode/extensions/rosc.vs64-2.6.2/tools/bc.py"

if [ -f "$PYTHON_EXE" ] && [ -f "$BC_EXE" ]; then
    "$PYTHON_EXE" "$BC_EXE" --crunch --map "c64/build/basic-template.bmap" \
        -I "c64" -I "c64/build" \
        -o "c64/build/basic-template.prg" "c64/src/main.bas"
else
    echo "❌ Error: VS64 extension tools not found at $PYTHON_EXE"
    mv "c64/src/main.bas.bak" "c64/src/main.bas"
    exit 1
fi

# Restore original source file
mv "c64/src/main.bas.bak" "c64/src/main.bas"

# Create d64 image from the PRG file
echo "💾 Creating d64 image..."
PRG_FILE="c64/build/basic-template.prg"
D64_FILE="c64/build/basic-template.d64"

if [ ! -f "$PRG_FILE" ]; then
    echo "❌ Error: PRG file not found at $PRG_FILE"
    exit 1
fi

# Use lowercase here so c1541 writes a PETSCII name that BASIC can resolve
# with LOAD "BASIC-TEMPLATE",8,1 in the default C64 character mode.
c1541 -format "basic-template,00" d64 "$D64_FILE" -write "$PRG_FILE" "basic-template"

# Create the zip package using PowerShell
echo "📦 Creating zip package..."
ZIP_FILE="c64/build/basic-template-v${VERSION}.zip"

# Remove old zip if it exists
rm -f "$ZIP_FILE"

# Use PowerShell to create zip (works on Windows)
powershell -Command "Compress-Archive -Path 'c64/build/basic-template.prg', 'c64/build/basic-template.d64' -DestinationPath '$ZIP_FILE' -Force"

echo ""
echo "✅ Packaging complete!"
echo "📦 Created: $ZIP_FILE"
echo "   - basic-template.prg"
echo "   - basic-template.d64"
