@echo off
setlocal

cmake -S . -B build
if errorlevel 1 exit /b %errorlevel%

cmake --build build --config Debug
if errorlevel 1 exit /b %errorlevel%

ctest --test-dir build -C Debug --output-on-failure
if errorlevel 1 exit /b %errorlevel%

exit /b 0
