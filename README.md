# 42 Cleaner

A cleanup script to keep your 42 iMac clean and patched.

## What It Does

-   Deletes All 42 Cache
-   Empties The Trash
-   XCode DerivedData and Archives
-   VS Code Caches
-   User Cache
-   User Logs
-   User Application Logs
-   User Application Caches
-   Deletes The QuickLook files
-   pip Cache
-   Cleans Homebrew
-   Clean npm cache
-   Clean yarn cache

## Install

Run this command from your terminal

```sh
curl -fsSL https://raw.githubusercontent.com/occulte/42Cleaner/master/installer.sh | zsh
```

## Running

After `Install` you now can run the script

```
$ clean --help
```

## How it works

This script installs it properly from the Github repository.

Then it simply creates a `.cleaner.sh` script in your home directory, and modifies your `.zshrc` and `.bash_profile` to alias the script.

It is simple to remove.
