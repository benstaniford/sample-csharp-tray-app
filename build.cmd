@echo off
REM Build script for Sample Tray App application and installer

echo ================================================
echo Building Sample Tray App
echo ================================================

echo.
echo Step 1: Restoring NuGet packages...
dotnet restore
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to restore packages
    exit /b %ERRORLEVEL%
)

echo.
echo Step 2: Building SampleTrayApp application (Release)...
dotnet build SampleTrayApp.csproj -c Release
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to build application
    exit /b %ERRORLEVEL%
)

echo.
echo Step 3: Checking for WiX toolset...
dotnet wix --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo WiX toolset not found. Installing...
    dotnet tool install --global wix
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to install WiX toolset
        exit /b %ERRORLEVEL%
    )
)

echo.
echo Step 4: Building MSI installer...
dotnet build SampleTrayApp.Installer\SampleTrayApp.Installer.wixproj -c Release
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to build installer
    exit /b %ERRORLEVEL%
)

echo.
echo ================================================
echo Build completed successfully!
echo ================================================
echo.
echo Application: bin\Release\net8.0-windows\SampleTrayApp.exe
echo Installer:   SampleTrayApp.Installer\bin\Release\x64\en-US\SampleTrayAppSetup.msi
echo.
pause
