---
name: "init"
description: "Оркеструвати повну ідемпотентну ініціалізацію C++/CMake/GoogleTest проєкту."
agent: "Build & CI/CD Engineer"
argument-hint: "Послідовно ініціалізувати, зібрати, налаштувати CI та перевірити проєкт"
---

# Команда `init`

## Передумови

- Робочий каталог є коренем проєкту.
- Доступні Git, CMake і C++ компілятор.
- Доступні команди `git-init`, `create-project`, `create-build`,
  `create-actions` і `check`.
- Повторний запуск має зберігати користувацькі зміни та не руйнувати файли.

## Дії

Викликай команди строго послідовно:

1. `git-init`
2. `create-project`
3. `create-build`
4. `create-actions`
5. `check`

Перед переходом до наступної команди перевіряй успішний статус попередньої та
передавай далі її результати (шляхи файлів, статус CMake/CTest, діагностику).
Повторний запуск має бути ідемпотентним: оновлюй лише керовані файли, не
видаляй файли та не скидай незбережені зміни. Після кожного кроку додавай рядок
до підсумкової таблиці `етап → статус`. При першій помилці негайно зупинися і
не запускай наступні етапи.

## Очікувані файли

Після успішного завершення мають існувати:

- `.gitignore` з `build/`;
- `src/main.cpp` і `tests/`;
- `CMakeLists.txt`, тест `BasicAddition`, каталог `build/` і запуск `hello`
  з виводом `Hello World`;
- `docs/architecture.md`, `docs/usage.md`;
- `.github/workflows/ci.yml`, `ci.sh`, `ci.bat`.

## Команди перевірки

Кожен етап виконує власні перевірки. Підсумковий етап `check` має виконати:

```sh
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```

Фінальний статус `init` — успішний лише за умови успішного завершення всіх
п’яти команд, проходження `BasicAddition`, запуску `hello` і повного `check`.
Наприкінці виведи таблицю:

| Етап | Статус |
|---|---|
| git-init | passed/failed |
| create-project | passed/failed |
| create-build | passed/failed |
| create-actions | passed/failed |
| check | passed/failed |

Для PowerShell фінального етапу використовуй еквівалентні перевірки:

```powershell
cmake -S . -B build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
cmake --build build --config Debug
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
ctest --test-dir build -C Debug --output-on-failure
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
if ((& .\build\bin\Debug\hello.exe) -ne "Hello World") { exit 1 }
```

## Повідомлення про помилку

`init: зупинено після команди <назва-команди>: <повідомлення>. Наступні етапи не запускаються. Таблиця етапів: <етап → статус>.`

Оркестратор негайно зупиняється при першій помилці, передає користувачу назву
етапу, команду, код завершення та діагностику. Не переходь до наступних команд,
не маскуй збій, не оголошуй проєкт готовим і виведи таблицю `етап → статус` з
`failed` для поточного етапу та `not-run` для наступних. Після виправлення дозволено
повторно запустити `init`; ідемпотентні команди не повинні руйнувати наявні
файли.
