@echo off

REM Building DLT Viewer on Windows
REM Script created by converting from a Unix shell script

REM delete debtmp directory if exists
if exist debtmp rmdir /S /Q debtmp

REM get DTLREV
for /f %%i in ('git rev-list --all --count') do set DTLREV=%%i

REM Copying debian directory
xcopy /E /I bionic\debian debian

REM Replacing PACKAGE_REVISION in src\version.h
powershell -Command "(gc src\version.h) -replace '#define PACKAGE_REVISION', '#define PACKAGE_REVISION ""%DTLREV%""' | Out-File -encoding ASCII src\version.h"

REM get DLT_VERSION
for /f "tokens=3 delims= " %%a in ('findstr /R /C:"PACKAGE_VERSION " /C:"PACKAGE_VERSION_STATE" src\version.h') do set DLT_VERSION=%%a

REM Echo DLT_VERSION and DTLREV
echo DLT_VERSION: %DLT_VERSION%, %DTLREV%

REM Create debtmp\dlt-viewer-%DLT_VERSION%
if not exist debtmp\dlt-viewer-%DLT_VERSION% mkdir debtmp\dlt-viewer-%DLT_VERSION%

REM Rsync equivalent in Windows
xcopy /E /I /EXCLUDE:exclusionList.txt * debtmp\dlt-viewer-%DLT_VERSION%

REM Change to new directory
cd debtmp\dlt-viewer-%DLT_VERSION%

REM Tar and Gzip equivalent in Windows
powershell -Command "Compress-Archive -Path * -DestinationPath ..\genivi-dlt-viewer_%DLT_VERSION%.zip"

REM Replace with your build command for Windows
REM This is typically project-specific and may involve a build system like CMake or MSBuild
REM Example: MSBuild.exe /property:Configuration=Release

