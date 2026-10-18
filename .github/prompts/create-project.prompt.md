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
2. Передай йому корінь репозиторію, вимогу C++/CMake/GoogleTest та наявні
   файли, які потрібно зберегти.
3. Перевір, що scaffold створив базову структуру і не видалив користувацькі
   зміни.

## Очікувані файли

- `src/main.cpp` із виведенням `Hello World`;
- `tests/`;
- `.gitignore` із правилом `build/`.

## Команди перевірки

```sh
test -f src/main.cpp
grep -Fq "Hello World" src/main.cpp
test -d tests
grep -Eq '(^|/)build(/|$)' .gitignore
```

## Повідомлення про помилку

`create-project: skill project-scaffold завершився помилкою: <повідомлення>.`

Зупини виконання та не переходь до `create-build`, доки всі очікувані файли не
пройшли перевірку.

