---
name: github-actions
description: "Застосовуй для створення кросплатформного GitHub Actions CI/CD для CMake та GoogleTest."
---

# Навичка `github-actions`

## Коли застосовувати

Застосовуй після успішного локального налаштування `build-and-test`, коли
потрібна автоматична перевірка кожного push або pull request на Linux, Windows
і macOS. Повторний запуск має оновлювати керовані CI-файли без видалення
користувацьких змін в інших частинах репозиторію.

## Вхідні дані

- кореневий каталог репозиторію;
- робочі `CMakeLists.txt`, `src/` і `tests/`;
- успішні команди локальної конфігурації, збірки та CTest;
- назви workflow, build-каталогу та тестових цілей;
- вимога підтримувати runner-и `ubuntu-latest`, `windows-latest` і
  `macos-latest`.

## Очікувані результати

Створи такі файли:

- `.github/workflows/ci.yml` — workflow, який запускається для push і pull
  request та має матрицю:
  `ubuntu-latest`, `windows-latest`, `macos-latest`;
- `ci.sh` — виконуваний Unix-скрипт для Linux/macOS, який безпосередньо
  виконує конфігурацію CMake, збірку та `ctest --output-on-failure`;
- `ci.bat` — Windows Batch-скрипт, який безпосередньо виконує ті самі кроки
  через CMake та CTest і повертає ненульовий код при помилці.

`ci.yml` має викликати `ci.sh` на `ubuntu-latest` і `macos-latest`, а `ci.bat`
на `windows-latest`. Workflow не повинен дублювати команди збірки замість
скриптів: скрипти є єдиною точкою безпосереднього запуску локальної CI-перевірки.

Приклад логіки вибору кроків у workflow:

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
```

## Команди для перевірки

Перевір структуру й YAML:

```sh
test -f .github/workflows/ci.yml
test -f ci.sh
test -f ci.bat
grep -Fq "ubuntu-latest" .github/workflows/ci.yml
grep -Fq "windows-latest" .github/workflows/ci.yml
grep -Fq "macos-latest" .github/workflows/ci.yml
grep -Fq "ci.sh" .github/workflows/ci.yml
grep -Fq "ci.bat" .github/workflows/ci.yml
```

Перевір локальний запуск на Unix:

```sh
sh ci.sh
```

На Windows запусти:

```bat
ci.bat
```

Скрипти мають завершитися успішно лише після успішних `cmake`, збірки та
`ctest`. За наявності GitHub Actions linter додатково перевір YAML цим
інструментом.

## Дії при помилці

Якщо workflow або скрипт не проходить перевірку, зупини навичку та зафіксуй
runner, файл і команду, що завершилася помилкою. Спочатку перевір YAML,
умовний вибір платформи, права на запуск `ci.sh` і коректність команд CMake/
CTest. Виправ відповідний CI-файл і повтори локальну перевірку; не маскуй
помилки оператором, який завжди повертає успішний код.

Якщо помилка відтворюється лише на конкретній платформі, не оголошуй workflow
готовим: повідом платформу та повний діагностичний результат і зупини
оркестрацію до виправлення.

## Приклад входу

```yaml
workflow_file: .github/workflows/ci.yml
script_unix: ci.sh
script_windows: ci.bat
runner_matrix:
  - ubuntu-latest
  - windows-latest
  - macos-latest
artifact_name: hello-${{ runner.os }}
artifact_path: build/bin
```

## Обов'язкова конфігурація workflow

Використовуй такі тригери:

```yaml
on:
  push:
    branches: [develop, master, 'feature/**']
  pull_request:
    branches: [develop, master]
```

Workflow має містити одну job із матрицею трьох ОС, `actions/checkout@v4`,
`permissions: contents: read`, а також окремі кроки:

```yaml
- name: Run Unix CI
  if: runner.os != 'Windows'
  shell: sh
  run: sh ci.sh

- name: Run Windows CI
  if: runner.os == 'Windows'
  shell: cmd
  run: call ci.bat

- name: Upload hello
  uses: actions/upload-artifact@v4
  with:
    name: hello-${{ runner.os }}
    path: build/bin
    if-no-files-found: error
```

Не додавай секрети. `ci.sh` і `ci.bat` після CTest мають запускати `hello`,
перевіряти `Hello World` і повертати ненульовий код, якщо конфігурація, збірка,
тест або запуск програми завершилися невдало.

## Типовий сценарій помилки

**Симптом:** workflow завершується успішно, але artifact `hello` відсутній.
**Причина:** CI-скрипт не створив `hello` у `build/bin` або upload-крок має
неправильний шлях чи не використовує `if-no-files-found: error`.
**Виправлення:** узгодь `CMAKE_RUNTIME_OUTPUT_DIRECTORY`, шляхи в `ci.sh` і
`ci.bat` та `path: build/bin`, після чого повтори збірку, CTest, запуск
`hello` і завантаження artifact.
