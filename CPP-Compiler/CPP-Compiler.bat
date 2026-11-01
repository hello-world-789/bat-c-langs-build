@echo off
chcp 65001 >nul
title BUILD ALL CPP
cd /d "%~dp0"

if not exist build mkdir build

if not defined CXX set "CXX=g++"
where "%CXX%" >nul 2>&1
if errorlevel 1 if not exist "%CXX%" (
    for %%p in ("C:\MinGW\bin" "C:\Program Files\CodeBlocks\MinGW\bin" "C:\msys64\ucrt64\bin" "C:\msys64\mingw64\bin") do (
        if exist "%%~p\g++.exe" set "CXX=%%~p\g++.exe"
    )
)
where "%CXX%" >nul 2>&1
if errorlevel 1 if not exist "%CXX%" (
    echo [ERROR] g++ not found. Install MinGW-w64:
    echo https://github.com/niXman/mingw-builds-binaries/releases
    pause
    exit /b 1
)

echo [BUILD] Using compiler: %CXX%
echo.

set /a ok=0
set /a fail=0
set /a total=0

for %%f in (*.cpp) do (
    set /a total+=1
    echo [COMPILING] %%f ...
    "%CXX%" -O2 -std=c++17 -Wall "%%f" -o "build\%%~nf.exe" -lgdi32 -luser32 -static-libgcc -static-libstdc++ 2> "build\%%~nf.log"
    if errorlevel 1 (
        echo    [FAIL] see build\%%~nf.log
        set /a fail+=1
    ) else (
        if exist "build\%%~nf.log" del "build\%%~nf.log"
        echo    [OK]   build\%%~nf.exe
        set /a ok+=1
    )
)

echo.
echo ==========================================
if %total%==0 (
    echo [WARN] No .cpp files found in this folder.
) else (
    echo [DONE] Success: %ok%   Failed: %fail%
)
echo Exe files are in the "build" folder.
echo ==========================================
pause
