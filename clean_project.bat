@echo off
echo ========================================================
echo  DEEP CLEANING FLUTTER PROJECT FOR: %USERNAME%
echo ========================================================

echo [1/5] Removing Gradle caches...
if exist "android\.gradle" rmdir /s /q "android\.gradle"
if exist "android\.idea" rmdir /s /q "android\.idea"

echo [2/5] Removing Flutter/Build artifacts...
if exist "build" rmdir /s /q "build"
if exist ".dart_tool" rmdir /s /q ".dart_tool"

echo [3/5] Deleting stale local.properties...
if exist "android\local.properties" del "android\local.properties"

echo [4/5] Running Flutter Clean...
call flutter clean

echo [5/5] Regenerating Environment Config (flutter pub get)...
call flutter pub get

echo.
echo ========================================================
echo  SUCCESS! Environment reset for this computer.
echo  > Please RELOAD VS CODE (Ctrl+Shift+P -> Reload Window)
echo ========================================================
