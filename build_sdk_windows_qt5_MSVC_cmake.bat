REM @echo off

REM Date     Version   Author                Changes
REM 4.7.19   1.0       Alexander Wenzel      Update to Qt 5.12.4 and Visual Studio 2015
REM 25.11.20 1.1       Alexander Wenzel      Update to Qt 5.12.10
REM 11.1.21  1.2       Alexander Wenzel      Update to Qt 5.12.12, Visual Studio 2017 Build Tools, simplify and cmake
REM 27.1.21  1.2       Alexander Wenzel      Update using cmake install
REM 6.7.23   1.3       Bkoufu             Update to Qt 6.3.2, Visual Studio 2019 Build Tools

echo ************************************
echo ***      DLT Viewer SDK (cmake)  ***
echo ************************************

call build_config.bat

if "%WORKSPACE%"=="" (goto NO_WORKSPACE) else (goto WITH_WORKSPACE)

:NO_WORKSPACE
    echo WORKSPACE variable is not defined
    set SOURCE_DIR=%CD%
    set BUILD_DIR=%SOURCE_DIR%\build\release
    set DIST_DIR=%SOURCE_DIR%\build\dist

    if "%DLT_VIEWER_SDK_DIR%"=="" (
        set DLT_VIEWER_SDK_DIR=c:\DltViewerSDK
    )

    goto Continue1
:WITH_WORKSPACE
    set SOURCE_DIR=%WORKSPACE%
    set BUILD_DIR=%SOURCE_DIR%\build\release
    set DIST_DIR=%SOURCE_DIR%\build\dist

    if "%DLT_VIEWER_SDK_DIR%"=="" (
        set DLT_VIEWER_SDK_DIR=%DIST_DIR%\DltViewerSDK
    )
:Continue1

echo ************************************
echo * QTDIR     = %QTDIR%
echo * MSVC_DIR  = %MSVC_DIR%
echo * PATH      = %PATH%
echo * DLT_VIEWER_SDK_DIR = %DLT_VIEWER_SDK_DIR%
echo * SOURCE_DIR         = %SOURCE_DIR%
echo * BUILD_DIR          = %BUILD_DIR%
echo * DIST_DIR           = %DIST_DIR%
echo ************************************

if exist build (
echo ************************************
echo ***  Delete old build Directory  ***
echo ************************************

    rmdir /s /q build || rem
    if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER

)
echo ************************************
echo ***  Configure MSVC environment  ***
echo ************************************

call vcvarsall.bat x86_amd64
if %ERRORLEVEL% NEQ 0 goto ERROR_HANDLER
echo configuring was successful

if exist %DLT_VIEWER_SDK_DIR% (
echo ************************************
echo ***   Delete old SDK Directory   ***
echo ************************************

    rmdir /s /q %DLT_VIEWER_SDK_DIR% || rem
    if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER
)

echo ************************************
echo ***       Build DLT Viewer       ***
echo ************************************

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
set PATH=E:\python\IVILogAnalyzer\dlt-viewer;%PATH%
set PATH=C:\Qt\Tools\CMake_64\bin;%PATH%
echo PATH updated to: %PATH%


if exist build (
    rmdir /s /q build
    if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER
)

mkdir build
if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER
cd build
if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER

call cmake .. -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%DLT_VIEWER_SDK_DIR%
if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER

call nmake
if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER

call nmake install
if %ERRORLEVEL% NEQ 0 GOTO ERROR_HANDLER
cmake -DQt6_DIR="%QTDIR%\lib\cmake\Qt6"

REM ... (rest of your script)
echo ************************************
echo ***       Build finished         ***
echo ************************************

cd ..

goto FINISH

:ERROR_HANDLER
echo Error occurred
exit /b %ERRORLEVEL%

:FINISH
echo Build finished

