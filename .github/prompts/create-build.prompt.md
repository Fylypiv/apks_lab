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
cmake --build build
ctest --test-dir build --output-on-failure
```

Очікується успішна збірка та проходження `BasicAddition`.

## Повідомлення про помилку

`create-build: помилка CMake/збірки/CTest на етапі <етап>: <повідомлення>.`

Зупини виконання, збережи діагностику та не переходь до `create-actions`, якщо
`cmake`, збірка або `ctest` завершилися невдало.

