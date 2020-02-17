@echo Off
REM ALert Log Script
REM -----------------
REM Quistor 18/08/2019

REM Setting up variables:

set "Customer=ZorgCirkel" 
set "DatabaseInstanceName=CRS"

set "ORACLE_SID=CRS"
set "ScriptsPath=D:\test"
set "Oracle_alert_log=D:\test\alert_log.txt"
set "Oracle_alert_log_old=D:\test\tmp\alert_log_old.txt"

Set "results_mail=%ScriptsPath%\tmp\alert_log_errors_%DatabaseInstanceName%.txt"

:main
FC %Oracle_alert_log% %Oracle_alert_log_old% >NUL

set "err_lvl=%ERRORLEVEL%"


if %err_lvl%==2 goto new_file

if %err_lvl%==1 goto diff

if %err_lvl%==0 goto no_diff


echo ------------------------------
echo Warning : Error lvl: %errorlevel%
echo ------------------------------
pause
goto end

:no_diff
echo No differences were found.
goto end

:diff
echo Differences were found.
FC %Oracle_alert_log% %Oracle_alert_log_old% | findstr "ORA- ALTER ERROR" | findstr /v /c:"ALTER SYSTEM ARCHIVE LOG" | findstr /v /c:"ORA-28" | findstr /v /c:"BEGIN BACKUP" | findstr /v /c:"END BACKUP" > %results_mail%

REM cscript %ScriptsPath%\FindinFile.vbs %results_mail% /ValueFile %ValueFile% %Customer% %results_autotask%
goto end



:new_file
copy /y %Oracle_alert_log% %Oracle_alert_log_old%
echo No file was found. Copied over alert log.


:end
pause
exit