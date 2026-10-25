---
name: "check"
description: "Лише перевірити структуру, CMake-збірку та CTest без зміни файлів."
agent: "Build & CI/CD Engineer"
argument-hint: "Перевірити готовність C++ проєкту без внесення змін"
---

# Команда `check`

## Передумови

- Проєкт уже створено.
- Існують `src/main.cpp`, `tests/`, `CMakeLists.txt` і `.gitignore`.
- Доступні `cmake`, компілятор і `ctest`.

## Дії

1. Перевір наявність очікуваних файлів і каталогів.
2. Запусти конфігурацію CMake в `build/`.
3. Запусти збірку через CMake.
4. Запусти `ctest -C Debug --output-on-failure`.
5. Запусти `hello` та перевір вивід `Hello World`.
6. Перевір manifest, skills, prompts, документацію, workflow і список
   відстежуваних файлів за командами нижче.
7. Повідом лише результати перевірок.

**Ця команда не змінює керовані файли проєкту.** Не створюй, не редагуй і не
видаляй вихідні файли, не оновлюй `.gitignore`, не запускай skills, що
генерують файли, і не змінюй стан Git. CMake може створити або оновити
ігнорований каталог `build/` та його артефакти як необхідну частину перевірки;
не додавай ці артефакти до репозиторію.

## Очікувані файли

Команда не створює й не оновлює файли. Вона лише перевіряє наявність:

- `src/main.cpp`;
- `tests/`;
- `CMakeLists.txt`;
- `.gitignore`;
- `.github/agents/build-engineer.agent.md`;
- усі шість prompt-файлів у `.github/prompts/`;
- три `SKILL.md` у `.github/skills/`;
- `docs/architecture.md`, `docs/usage.md`;
- `.github/workflows/ci.yml`, `ci.sh`, `ci.bat`.

## Команди перевірки

```sh
test -f src/main.cpp
test -d tests
test -f CMakeLists.txt
test -f .gitignore
test -f .github/agents/build-engineer.agent.md
for f in .github/prompts/{git-init,create-project,create-build,create-actions,check,init}.prompt.md; do test -f "$f"; done
for f in .github/skills/{project-scaffold,build-and-test,github-actions}/SKILL.md; do test -f "$f"; done
test -f docs/architecture.md
test -f docs/usage.md
grep -Fq "Доступні skills" .github/agents/build-engineer.agent.md
grep -Fq "Доступні commands" .github/agents/build-engineer.agent.md
grep -Fq "git-init" .github/agents/build-engineer.agent.md
grep -Fq "project-scaffold" .github/skills/project-scaffold/SKILL.md
grep -Fq "build-and-test" .github/skills/build-and-test/SKILL.md
grep -Fq "github-actions" .github/skills/github-actions/SKILL.md
grep -Eq "git-init.*create-project.*create-build.*create-actions.*check" .github/prompts/init.prompt.md
for p in ubuntu-latest windows-latest macos-latest ci.sh ci.bat upload-artifact; do grep -Fq "$p" .github/workflows/ci.yml; done
if command -v actionlint >/dev/null 2>&1; then actionlint .github/workflows/ci.yml; else python -c 'import yaml, pathlib; yaml.safe_load(pathlib.Path(".github/workflows/ci.yml").read_text())'; fi
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
test "$(build/bin/hello)" = "Hello World"
if git ls-files | grep -Eq '(^|/)build/|(^|/)\.env$|\.pem$|\.key$'; then exit 1; fi
```

У PowerShell:

```powershell
foreach ($file in @("src\main.cpp", "tests", "CMakeLists.txt", ".gitignore",
  ".github\agents\build-engineer.agent.md", "docs\architecture.md",
  "docs\usage.md", ".github\workflows\ci.yml", "ci.sh", "ci.bat")) {
  if (!(Test-Path $file)) { Write-Error "структура: $file"; exit 1 }
}
foreach ($file in @(
  ".github\prompts\git-init.prompt.md",
  ".github\prompts\create-project.prompt.md",
  ".github\prompts\create-build.prompt.md",
  ".github\prompts\create-actions.prompt.md",
  ".github\prompts\check.prompt.md",
  ".github\prompts\init.prompt.md",
  ".github\skills\project-scaffold\SKILL.md",
  ".github\skills\build-and-test\SKILL.md",
  ".github\skills\github-actions\SKILL.md"
)) { if (!(Test-Path $file)) { Write-Error "структура: $file"; exit 1 } }
$manifest = Get-Content -Raw .github\agents\build-engineer.agent.md
foreach ($pattern in @("Build & CI/CD Engineer", "Заборонені дії",
  "Критерії завершення", "Доступні skills", "Доступні commands")) {
  if ($manifest -notmatch [regex]::Escape($pattern)) { Write-Error "manifest: $pattern"; exit 1 }
}
$init = Get-Content -Raw .github\prompts\init.prompt.md
if ($init.IndexOf("git-init") -gt $init.IndexOf("create-project") -or
    $init.IndexOf("create-project") -gt $init.IndexOf("create-build") -or
    $init.IndexOf("create-build") -gt $init.IndexOf("create-actions") -or
    $init.IndexOf("create-actions") -gt $init.IndexOf("check")) { Write-Error "prompts: init order"; exit 1 }
foreach ($skill in @(
  ".github\skills\project-scaffold\SKILL.md",
  ".github\skills\build-and-test\SKILL.md",
  ".github\skills\github-actions\SKILL.md"
)) {
  $text = Get-Content -Raw $skill
  foreach ($section in @("Коли застосовувати|Призначення", "Вхідні дані", "Очікувані результати",
    "Команди для перевірки", "Дії при помилці", "Приклад входу")) {
    if ($section -notmatch "\|" -and $text -notmatch [regex]::Escape($section)) { Write-Error "skill: $skill"; exit 1 }
    if ($section -match "\|" -and $text -notmatch $section) { Write-Error "skill: $skill"; exit 1 }
  }
}
$workflow = Get-Content -Raw .github\workflows\ci.yml
foreach ($pattern in @("ubuntu-latest", "windows-latest", "macos-latest",
  "ci.sh", "ci.bat", "upload-artifact")) {
  if ($workflow -notmatch [regex]::Escape($pattern)) { Write-Error "workflow: $pattern"; exit 1 }
}
if (Get-Command actionlint -ErrorAction SilentlyContinue) {
  actionlint .github\workflows\ci.yml
} else {
  python -c "import yaml, pathlib; yaml.safe_load(pathlib.Path('.github/workflows/ci.yml').read_text())"
}
cmake -S . -B build
if ($LASTEXITCODE -ne 0) { Write-Error "cmake"; exit 1 }
cmake --build build --config Debug
if ($LASTEXITCODE -ne 0) { Write-Error "build"; exit 1 }
ctest --test-dir build -C Debug --output-on-failure
if ($LASTEXITCODE -ne 0) { Write-Error "ctest"; exit 1 }
if ((& .\build\bin\Debug\hello.exe) -ne "Hello World") { Write-Error "hello"; exit 1 }
$tracked = git ls-files
if ($tracked | Select-String -Pattern '(^|/)build/|(^|/)\.env$|\.pem$|\.key$') { Write-Error "git ls-files"; exit 1 }
```

Ця команда не редагує керовані файли. Каталог `build/` може бути створений
CMake як ігнорований артефакт перевірки. Для YAML спочатку використовуй
`actionlint`, а якщо його немає — `python` з `yaml.safe_load`.

## Повідомлення про помилку

`check: перевірку не пройдено на етапі <структура|manifest|skills|prompts|docs|workflow|yaml|cmake|build|ctest|hello|git>: <повідомлення>.`

Поверни ненульовий статус, зафіксуй діагностику та не маскуй помилку
успішним результатом. Не виправляй її в межах цієї команди.
