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
4. Попроси додати тригери `push` для `develop`, `master`, `feature/**` та
   `pull_request` для `develop` і `master`.
5. Попроси додати `actions/upload-artifact@v4` з artifact
   `hello-${{ runner.os }}` і шляхом `build/bin`.
6. Перевір, що скрипти безпосередньо запускають CMake, збірку, CTest і
   `hello`, перевіряючи `Hello World`.

## Очікувані файли

- `.github/workflows/ci.yml` із матрицею трьох платформ;
- `ci.sh` для Linux/macOS;
- `ci.bat` для Windows.
- `.github/workflows/ci.yml` із потрібними тригерами та кроком
  `actions/upload-artifact@v4`.

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
grep -Fq "develop" .github/workflows/ci.yml
grep -Fq "master" .github/workflows/ci.yml
grep -Fq "feature/**" .github/workflows/ci.yml
grep -Fq "actions/upload-artifact@v4" .github/workflows/ci.yml
grep -Fq "hello-${{ runner.os }}" .github/workflows/ci.yml
grep -Fq "build/bin" .github/workflows/ci.yml
grep -Fq "hello" ci.sh
grep -Fq "Hello World" ci.sh
grep -Fq "hello" ci.bat
grep -Fq "Hello World" ci.bat
sh ci.sh
```

У PowerShell:

```powershell
foreach ($file in @(".github\workflows\ci.yml", "ci.sh", "ci.bat")) {
  if (!(Test-Path $file)) { exit 1 }
}
$workflow = Get-Content -Raw .github\workflows\ci.yml
foreach ($pattern in @("ubuntu-latest", "windows-latest", "macos-latest",
  "ci.sh", "ci.bat", "develop", "master", "feature/**",
  "actions/upload-artifact@v4", "hello-${{ runner.os }}", "build/bin")) {
  if ($workflow -notmatch [regex]::Escape($pattern)) { exit 1 }
}
Select-String -Path ci.sh -Pattern "hello|Hello World"
Select-String -Path ci.bat -Pattern "hello|Hello World"
cmd /c ci.bat
```

На Windows додатково виконай `ci.bat`; обидва скрипти мають завершити запуск
`hello` з виводом `Hello World`.

## Повідомлення про помилку

`create-actions: skill github-actions завершився помилкою на платформі/файлі <контекст>: <повідомлення>.`

Зупини оркестрацію, якщо workflow невалідний або будь-який CI-скрипт не
завершується успішно.
