---
name: "create-build"
description: "Налаштувати CMake, GoogleTest і CTest через skill build-and-test."
agent: "Build & CI/CD Engineer"
argument-hint: "Сконфігурувати build/, зібрати hello і запустити BasicAddition"
---

# Команда `create-build`

## Передумови

- Виконано `create-project`.
- Наявні `src/main.cpp` і каталог `tests/`.
- Доступні `cmake` та C++ компілятор.
- Доступний skill [build-and-test](../skills/build-and-test/SKILL.md).

## Дії

1. Виклич skill `build-and-test`.
2. Передай корінь проєкту, назву цілі `hello`, вимогу GoogleTest і тест
   `BasicAddition`.
3. Дозволь skill створити або оновити `CMakeLists.txt` і тестовий файл.
4. Виконай конфігурацію, збірку та тестування в окремому `build/`.

## Очікувані файли

- `CMakeLists.txt` із ціллю `hello`, GoogleTest і CTest;
- `tests/test_basic_addition.cpp` із тестом `BasicAddition`;
- `build/` із результатами конфігурації та компіляції.

## Команди перевірки

```sh
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
test "$(build/bin/hello)" = "Hello World"
```

У PowerShell:

```powershell
cmake -S . -B build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
cmake --build build --config Debug
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
ctest --test-dir build -C Debug --output-on-failure
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ((& .\build\bin\Debug\hello.exe) -ne "Hello World") { exit 1 }
```

Очікується успішна збірка, проходження `BasicAddition` і виведення `Hello
World` виконуваним файлом `hello`. Для Visual Studio використовується шлях
`build/bin/Debug/hello.exe`; для Unix — `build/bin/hello`.

## Повідомлення про помилку

`create-build: помилка CMake/збірки/CTest на етапі <етап>: <повідомлення>.`

Зупини виконання, збережи діагностику та не переходь до `create-actions`, якщо
`cmake`, збірка або `ctest` завершилися невдало.
