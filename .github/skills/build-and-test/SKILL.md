---
name: build-and-test
description: "Застосовуй для налаштування CMake-збірки C++-проєкту та запуску GoogleTest через CTest."
---

# Навичка `build-and-test`

## Коли застосовувати

Застосовуй після `project-scaffold`, коли в репозиторії є `src/main.cpp` і
каталог `tests/`. Також застосовуй для повторної перевірки змін у C++-коді,
конфігурації CMake або тестах.

## Вхідні дані

- кореневий каталог проєкту;
- `src/main.cpp` і каталог `tests/`;
- назва CMake-проєкту та потрібний стандарт C++;
- доступний `cmake` і компілятор;
- вимога використовувати GoogleTest і CTest.

## Очікувані результати

Створи або онови такі файли:

- `CMakeLists.txt` — оголошує C++-проєкт, компілює `src/main.cpp` у виконувану
  ціль `hello`, підтягує GoogleTest через `FetchContent` або інший
  відтворюваний механізм і підключає CTest;
- `tests/test_basic_addition.cpp` — містить тестову функцію з обов'язковою
  назвою `BasicAddition`, яка перевіряє додавання двох чисел;
- `build/` — каталог поза вихідними файлами для результатів конфігурації,
  компіляції та тестування. Він не повинен потрапити до Git.

Тестова ціль має бути зареєстрована в CTest, а виконуваний тест має запускатися
через GoogleTest.

## Команди для перевірки

Виконай із кореня репозиторію:

```sh
cmake -S . -B build
cmake --build build
ctest --test-dir build -C Debug --output-on-failure
```

Очікуваний результат: конфігурація та збірка завершуються успішно, а CTest
показує успішне проходження тесту `BasicAddition`. Параметр `-C Debug`
потрібен для multi-config генераторів на кшталт Visual Studio; для іншої
конфігурації узгоджено заміни `Debug` на її назву.

## Дії при помилці

1. Зупини навичку після першої невдалої команди; не приховуй її код завершення
   або повідомлення компілятора.
2. Визнач етап помилки: конфігурація CMake, завантаження GoogleTest, компіляція
   або запуск CTest.
3. Виправ лише причину в `CMakeLists.txt`, коді чи тесті та повтори всі
   перевірки від невдалого етапу.
4. Якщо GoogleTest або компілятор недоступні, повідом назву відсутньої
   залежності та команду, яка це підтвердила; не підміняй тест ручним
   повідомленням про успіх.

Наступний етап дозволено запускати лише після успішного завершення `cmake`,
збірки та `ctest`.

## Додаткові налаштування CMake

У `CMakeLists.txt` перед `add_executable` додай:

```cmake
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
```

Це розміщує виконувані файли у `build/bin` і не збирає непотрібний GoogleMock.
Після `ctest` запусти `hello` та перевір точний вивід `Hello World`:

- Unix: `build/bin/hello`;
- Windows із Visual Studio: `build/bin/Debug/hello.exe`.

## Команди перевірки для платформ

Для `sh`:

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
test "$(build/bin/hello)" = "Hello World"
```

Для PowerShell:

```powershell
cmake -S . -B build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
cmake --build build --config Debug
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
ctest --test-dir build -C Debug --output-on-failure
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ((& .\build\bin\Debug\hello.exe) -ne "Hello World") { exit 1 }
```

Для одноконфігураційного Unix-генератора шлях до `hello` залишається
`build/bin/hello`; для Visual Studio використовується
`build/bin/Debug/hello.exe`.

## Приклад входу

```yaml
project_root: .
cmake_build_dir: build
configuration: Debug
test_name: BasicAddition
hello_output: "Hello World"
```

## Типовий сценарій помилки

**Симптом:** CTest проходить, але запуск `hello` завершується помилкою
«файл не знайдено». **Причина:** не задано
`CMAKE_RUNTIME_OUTPUT_DIRECTORY` або використано шлях Unix для Visual Studio.
**Виправлення:** додай потрібні `set(...)` перед `add_executable`, перебудуй
проєкт і використовуй `build/bin/hello` на Unix або
`build/bin/Debug/hello.exe` у Visual Studio.
