# Використання проєкту

## Запуск агента

У Copilot Chat виконайте запит:

```text
Виконай prompt init.prompt.md з .github/prompts
```

Не використовуйте `/init`, оскільки він збігається з вбудованою командою
Copilot.

## Локальна перевірка в sh

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
sh ci.sh
```

## Локальна перевірка в PowerShell

```powershell
cmake -S . -B build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
cmake --build build --config Debug
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
ctest --test-dir build -C Debug --output-on-failure
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
cmd /c ci.bat
```

## Запуск hello

На Unix:

```sh
./build/bin/hello
```

У Windows із Visual Studio:

```powershell
.\build\bin\Debug\hello.exe
```

Очікуваний вивід:

```text
Hello World
```

## CI

Workflow `.github/workflows/ci.yml` запускається для гілок `develop`, `master`
і `feature/**`, а також для pull request у `develop` і `master`. Одна job із
матрицею `ubuntu-latest`, `windows-latest` і `macos-latest` викликає `ci.sh`
або `ci.bat`. Скрипти виконують конфігурацію CMake, збірку, CTest і запускають
`hello`; після цього workflow завантажує виконуваний файл як artifact.
