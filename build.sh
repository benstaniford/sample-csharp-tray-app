#!/bin/bash
# Build script for Sample Tray App application and installer

echo "================================================"
echo "Building Sample Tray App"
echo "================================================"

echo ""
echo "Step 1: Restoring NuGet packages..."
dotnet restore
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to restore packages"
    exit 1
fi

echo ""
echo "Step 2: Building SampleTrayApp application (Release)..."
dotnet build SampleTrayApp.csproj -c Release
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build application"
    exit 1
fi

echo ""
echo "Step 3: Checking for WiX toolset..."
if ! dotnet wix --version &> /dev/null; then
    echo "WiX toolset not found. Installing..."
    dotnet tool install --global wix
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install WiX toolset"
        exit 1
    fi
fi

echo ""
echo "Step 4: Building MSI installer..."
dotnet build SampleTrayApp.Installer/SampleTrayApp.Installer.wixproj -c Release
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build installer"
    exit 1
fi

echo ""
echo "================================================"
echo "Build completed successfully!"
echo "================================================"
echo ""
echo "Application: bin/Release/net8.0-windows/SampleTrayApp.exe"
echo "Installer:   SampleTrayApp.Installer/bin/Release/x64/en-US/SampleTrayAppSetup.msi"
echo ""
