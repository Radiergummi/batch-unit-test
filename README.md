# batch-unit-test
Simple unit testing framework for batch files

## Usage
Copy the `test.cmd` to a folder of your choice (your project root, most likely) and create a folder with the name `tests` there. Within this folder, you can create test instruction files which have to end in `.test.cmd` to be recognized as test instructions.  

To run all of your tests, open a command window and execute `test.cmd <path to script to test>` where the first parameter is your own script you wish to perform tests on. This file will be handed to all test instructions as a resolved path parameter.  
If you wish to log the testing, just use output redirection (`test.cmd %path% > unit-test-%date%.log`)

A short explanation is available through `test.cmd --help`.


## Writing tests
To write a test instruction, keep the following things in mind:  
- The parameter `%1` will point to the script you wish to test.
- The test outcome is determined by its errorlevel. `0` is interpreted as success, everything above as failure. The errorlevel will be shown in the console, so you can signal specific outcomes.
- Output you generate within the test file will be shown in the console. This allows for multiple tests to be grouped in the same test instruction file.

### Test example
A quick example test:

````batch
@echo off

:: set script file path
set scriptFile=%1

call %scriptFile% /foo /bar:%cd%\tests\fixtures\someFile.txt > %temp%\test_x.output

for /f "eol=; tokens=* delims=, " %%i in (%temp%\test_x.txt) do (
  if %%i == success (
    exit /b 0
  )
)

:: Expected outcome not met
exit /b 1
````
