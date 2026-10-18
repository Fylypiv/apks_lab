---
name: "create-actions"
description: "Створити кросплатформний GitHub Actions workflow і CI-скрипти через skill github-actions."
agent: "Build & CI/CD Engineer"
argument-hint: "Створити ci.yml, ci.sh і ci.bat"
---

# Команда `create-actions`

## Передумови

- Локальні `cmake`, збірка та `ctest` успішно завершилися.
- Наявні `CMakeLists.txt`, `src/` і `tests/`.
- Доступний skill [github-actions](../skills/github-actions/SKILL.md).

## Дії

1. Виклич skill `github-actions`.
2. Передай вимогу підтримати `ubuntu-latest`, `windows-latest` і
   `macos-latest`.
3. Попроси workflow викликати `ci.sh` на Linux/macOS та `ci.bat` на Windows.
4. Перевір, що скрипти безпосередньо запускають CMake, збірку й CTest.

## Очікувані файли

- `.github/workflows/ci.yml` із матрицею трьох платформ;
- `ci.sh` для Linux/macOS;
- `ci.bat` для Windows.

## Команди перевірки

```sh
test -f .github/workflows/ci.yml
test -f ci.sh
test -f ci.bat
grep -Fq "ubuntu-latest" .github/workflows/ci.yml
grep -Fq "windows-latest" .github/workflows/ci.yml
grep -Fq "macos-latest" .github/workflows/ci.yml
grep -Fq "ci.sh" .github/workflows/ci.yml
grep -Fq "ci.bat" .github/workflows/ci.yml
sh ci.sh
```

На Windows додатково виконай `ci.bat`.

## Повідомлення про помилку

`create-actions: skill github-actions завершився помилкою на платформі/файлі <контекст>: <повідомлення>.`

Зупини оркестрацію, якщо workflow невалідний або будь-який CI-скрипт не
завершується успішно.

