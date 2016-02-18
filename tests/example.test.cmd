@echo off

set scriptPath=%1
for %%F in (%1) do set scriptFilename=%%~nxF

echo Hello world!
echo This example test is set up to run tests on the file %scriptPath%.
echo Using its error level, you can give feedback to the main test process 
echo about the test outcome.
echo This could look like so:
echo.
echo.    if %%commandOutput%% == 0 (
echo.      echo Test 4/14: Pass.
echo.    ) else (
echo.      echo Test 4/14: FAILED! Expected 0 bot got %%commandOutput%%.
echo.      set %failed%=true
echo.    )
echo.
echo In the end, you should manage to keep track of failed tests and return 
echo an error level. Every value greater than 0 is taken as a sign the test 
echo experienced an error. This could look like so:
echo.
echo.    if %failed% == true (
echo.      exit /b 1
echo.    ) else (
echo.      exit /b 0
echo.    )

exit /b 0
