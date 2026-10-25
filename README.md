# Лабораторна робота №1: Проєктування AI-агента для автоматизації розробки та CI/CD

* **Студент:** Филипів Ігор Михайлович
* **Група:** КІ-405
* **Варіант:** 25 (варіант 1 за таблицею 1) (C++ | CMake | GoogleTest / CTest)

## Опис проєкту
Репозиторій містить AI-агента з навичками та командами для генерації, складання, тестування і налаштування CI/CD кросплатформного проєкту Hello World.

## Запуск агента
1. Переконайтеся, що встановлено розширення GitHub Copilot Chat.
2. Створіть та перейдіть у гілку `feature/...`.
3. Виконайте запит: `Виконай prompt init.prompt.md з .github/prompts`.
   Не використовуйте `/init`, оскільки цей запис збігається з вбудованою
   командою Copilot.

## Запуск проєкту

Виконайте з кореня репозиторію:

```sh
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug
./build/hello
```

У Windows із генератором Visual Studio:

```powershell
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug
.\build\Debug\hello.exe
```

Очікуваний вивід програми:

```text
Hello World
```