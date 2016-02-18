:: clear the screen
@cls

:: change encoding to allow for non ASCII-characters
@chcp 1252>nul

:: change working directory to current script directory
@cd /d %~dp0

:: disable echo
@echo off

:: start local context, enable delayed expansion
setlocal enableDelayedExpansion

:: unwrap parameter, add quotes if not present
set scriptToTest="%~1"

:: check if the first parameter is empty
if [%scriptToTest%] neq [""] (

	:: check if the first parameter is "--help"
	if [%scriptToTest%] == [--help] (
		call :help
		exit /b 0
	) else (
	
		:: check if the script to test does exist at all
		if not exist %scriptToTest% (
			echo. [FAIL]	the given file %scriptToTest% does not exist.
			exit /b 1
		)
		
		:: read all config values
		call :config
		
		:: start testing
		call :start %scriptToTest%
	)
) else (

	:: if we have no parameter given, show an error message and the help text
	echo.
	echo. Invalid syntax!
	call :help
	exit /b 1
)

:: end of script (only modules below)
goto :eof


::::
::
:: config module
:: sets all config values. could be replaced by ini reader or comparable.
::
:config
	set config.abortOnFail=false
	set config.supressOutput=false
exit /b 0


::::
::
:: start module
:: starts the unit testing for a given file
::
:start
	:: get script name from path
	for %%F in (%1) do set scriptFilename=%%~nxF

	echo.
	echo. ## Starting unit test of %scriptFilename% ##
	echo.

	:: set test status variable to 0 (=success)
	set /a testStatus=0

	:: set empty failed tests variable
	set failedTests=

	:: iterate over all *.test.cmd files in the tests directory
	for /f "tokens=*" %%i in ('forfiles /p "%cd%\tests" /m *.test.cmd /c "cmd /c if @isdir==FALSE echo @file"') do (
		
		:: retrieve the test name from the file name
		set testName=%%~i
		
		:: remove the ".test.cmd"-extension
		set testName=!testName:.test.cmd=!
		
		echo. [INFO] Testing: !testName!
		
		if %config.supressOutput% == true (
			:: execute the test, redirect output to nul
			call %cd%\tests\%%i %1 1>nul 2>&1
		) else (
			:: execute the test
			call %cd%\tests\%%i %1
		)
		
		:: store the error level
		set /a currentErrorlevel=!errorlevel!
		
		:: set the test status to the current error level
		set /a testStatus=!testStatus!+!currentErrorlevel!
		
		
		:: if we shall abort on the first failure, do it now
		if %config.abortOnFail% == true (
				if !currentErrorlevel! gtr 0 (
				echo. [FAIL]	Test !testName! failed: Aborting...
				exit /b !testStatus!
			) else (
				echo. [ OK ] Test !testName! completed successfully.
				echo.
			)
		) else (
			if !currentErrorlevel! gtr 0 (
				set failedTests=!failedTests! !testName!
				echo. [FAIL] Test !testName! failed ^(!currentErrorlevel!^).
				echo.
			) else (
				echo. [ OK ] Test !testName! completed successfully.
				echo.
			)
		)
	)
		
	:: if the test status is not successful, error out like so
	if !testStatus! gtr 0 (
		call :end !testStatus!
	) else (
		call :end 0
	)
exit /b 0



::::
::
:: help module
:: shows the help text
::
:help
echo.
echo. Batch file unit test framework ^(BaFUTeK 0.0.1^)
echo. 
echo. Syntax:
echo. startTest ^<script to test^>
echo.	script to test:	the batch script to test.



::::
::
:: end module
:: ends the unit test by evaluating the outcome. can be expanded 
:: for email delivery or log writing in automated systems.
::
:: %1: the error level code	
::
:end
	if %1 gtr 0 (
		echo. [FAIL]	testing did not finish successfully ^(%1^).
		
		endlocal
		exit /b 1
	) else (
		echo. [ OK ]	testing finished successfully.
		
		endlocal
		exit /b 0
	)
goto :eof
