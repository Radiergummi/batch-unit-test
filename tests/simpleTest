@echo off

echo Hey. This is an example on how to create a simple test file ^(one which is not
echo split in multiple sub-tests on one subject but rather stands for its own^).
echo The following script will try to write the name of the script file ^(the file 
echo to test^) to a logfile in the test root directory ^(the path the test.cmd script
echo is run from^). If that succeeds, it exits positively. If not, it exits negatively.
echo Of course, this somehow defeats the purpose of testing the script file, but it
echo shows you how to use batch-unit-test.

echo %1 > %cd%\batch-unit-test_simpleTest-output.log
:: of course you could shorten this to exit /b %errorlevel%
if errorlevel 1 (
  exit /b 1
)

exit /b 0
