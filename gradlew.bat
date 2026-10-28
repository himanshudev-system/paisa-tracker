@echo off
where gradle >nul 2>nul
if errorlevel 1 (
  echo Gradle is not installed or not available on PATH.
  echo This repo is missing the generated Gradle wrapper files, so this shim uses the installed Gradle binary instead.
  exit /b 1
)

gradle %*
