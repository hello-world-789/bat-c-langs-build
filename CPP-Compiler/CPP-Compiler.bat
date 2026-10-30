@echo off
chcp 65001 >nul
title BUILD ALL CPP
if not exist build mkdir build
set "CXX=g++"
where g++ >nul 2>&1
if errorlevel 1 (
    if exist "C:\MinGW\bin\g++.exe" (
        set "CXX=C:\MinGW\bin\g++.exe"
    ) else if exist "C:\Program Files\CodeBlocks\MinGW\bin\g++.exe" (
        set "CXX=C:\Program Files\CodeBlocks\MinGW\bin\g++.exe"
    ) else if exist "C:\msys64\ucrt64\bin\g++.exe" (
        set "CXX=C:\msys64\ucrt64\bin\g++.exe"
    ) else (
        echo [ERROR] g++ not found. Install MinGW-w64:
        echo https://github.com/niXman/mingw-builds-binaries/releases
        pause
        exit /b 1
    )
)

echo [BUILD] Using compiler: %CXX%
echo.

set /a ok=0
set /a fail=0

for %%f in (*.cpp) do (
    echo [COMPILING] %%f ...
    "%CXX%" -O2 -std=c++17 "%%f" -o "build\%%~nf.exe" -lgdi32 -luser32 -lkernel32 -lwinmm -static-libgcc -static-libstdc++ 2> "build\%%~nf.log"
    if errorlevel 1 (
        echo    [FAIL] see build\%%~nf.log
        set /a fail+=1
    ) else (
        echo    [OK]   build\%%~nf.exe
        set /a ok+=1
    )
)

echo.
echo ==========================================
echo [DONE] Success: %ok%   Failed: %fail%
echo Exe files are in the "build" folder.
echo ==========================================
pause
