@if "%OS%"=="Windows_NT" echo "Windows"

echo "Display all variables"

set

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%

