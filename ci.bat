@echo off
setlocal

cmake -S . -B build
if errorlevel 1 exit /b %errorlevel%

cmake --build build --config Debug
if errorlevel 1 exit /b %errorlevel%

ctest --test-dir build -C Debug --output-on-failure
if errorlevel 1 exit /b %errorlevel%

for /f "delims=" %%A in ('build\bin\Debug\hello.exe') do set "HELLO_OUTPUT=%%A"
if not "%HELLO_OUTPUT%"=="Hello World" exit /b 1

exit /b 0
