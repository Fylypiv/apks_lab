---
name: "create-project"
description: "Створити початкову структуру C++ проєкту через skill project-scaffold."
agent: "Build & CI/CD Engineer"
argument-hint: "Створити src/, tests/, Hello World і .gitignore"
---

# Команда `create-project`

## Передумови

- Виконано `git-init` або вже існує Git-репозиторій.
- Робочий каталог є коренем проєкту.
- Доступний skill [project-scaffold](../skills/project-scaffold/SKILL.md).

## Дії

1. Виклич skill `project-scaffold`.
2. Передай йому корінь репозиторію, `language: C++`,
   `project_name: apks_lab`, вимогу CMake/GoogleTest та наявні файли, які
   потрібно зберегти.
3. Перевір, що scaffold створив базову структуру і не видалив користувацькі
   зміни.

## Очікувані файли

- `src/main.cpp` із виведенням `Hello World`;
- `tests/`;
- `.gitignore` із правилом `build/`.
- `docs/architecture.md`;
- `docs/usage.md`;
- `README.md`, якщо його не існувало; наявний README не перезаписується.

## Команди перевірки

```sh
test -f src/main.cpp
grep -Fq "Hello World" src/main.cpp
test -d tests
grep -Eq '(^|/)build(/|$)' .gitignore
test -f docs/architecture.md
test -f docs/usage.md
test -f README.md
grep -Fq "Запуск агента" README.md
grep -Fq "Запуск проєкту" README.md
```

У PowerShell:

```powershell
if (!(Test-Path src\main.cpp)) { exit 1 }
Select-String -Path src\main.cpp -Pattern "Hello World"
if (!(Test-Path tests)) { exit 1 }
Select-String -Path .gitignore -Pattern "build/"
if (!(Test-Path docs\architecture.md)) { exit 1 }
if (!(Test-Path docs\usage.md)) { exit 1 }
if (!(Test-Path README.md)) { exit 1 }
Select-String -Path README.md -Pattern "Запуск агента"
Select-String -Path README.md -Pattern "Запуск проєкту"
```

## Повідомлення про помилку

`create-project: skill project-scaffold завершився помилкою: <повідомлення>.`

Зупини виконання та не переходь до `create-build`, доки всі очікувані файли не
пройшли перевірку.
