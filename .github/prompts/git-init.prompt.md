---
name: "git-init"
description: "Перевірити Git-репозиторій і підготувати .gitignore для C++/CMake проєкту."
agent: "Build & CI/CD Engineer"
argument-hint: "Підготувати Git-репозиторій у корені проєкту"
---

# Команда `git-init`

## Передумови

- Робочий каталог визначено як корінь проєкту.
- Доступна команда `git`.
- Потрібно зберегти наявні файли та зміни користувача.

## Дії

1. Перевір, чи є поточний каталог Git-репозиторієм.
2. Якщо репозиторій відсутній, виконай `git init`.
3. Створи або обережно онови `.gitignore`, зберігши наявні правила.
4. Додай правило `build/` для ігнорування каталогу збірки та типові артефакти
   CMake/компілятора, а також `.env`, `*.pem`, `*.key` і `.vs/`.
5. Покажи стан репозиторію командою `git status --short`.

Не видаляй файли, не скидай незбережені зміни та не створюй коміт без окремого
доручення.

## Очікувані файли

- `.git/` — наявний або щойно ініціалізований Git-репозиторій;
- `.gitignore` — містить `build/`, `.env`, `*.pem`, `*.key`, `.vs/` і не
  втрачає попередніх правил.

## Команди перевірки

```sh
git rev-parse --is-inside-work-tree
grep -Eq '(^|/)build(/|$)' .gitignore
grep -Fxq '.env' .gitignore
grep -Fq '*.pem' .gitignore
grep -Fq '*.key' .gitignore
grep -Fq '.vs/' .gitignore
git status --short
```

У PowerShell перевір правило через:

```powershell
git rev-parse --is-inside-work-tree
Select-String -Path .gitignore -Pattern "^build/$"
Select-String -Path .gitignore -SimpleMatch -Pattern ".env"
Select-String -Path .gitignore -SimpleMatch -Pattern "*.pem"
Select-String -Path .gitignore -SimpleMatch -Pattern "*.key"
Select-String -Path .gitignore -SimpleMatch -Pattern ".vs/"
git status --short
```

## Повідомлення про помилку

`git-init: помилка на етапі <етап>: <повідомлення>. Наступні етапи не запускаються.`
