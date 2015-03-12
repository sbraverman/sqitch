@ECHO OFF

REM 'escalation' refers to the user becoming a member of Informatics Systems Admins

REM Treat 'sqitch help' as a local command (Don't escalate)
IF "%1"=="help" GOTO LocalCmd

REM If a user just types 'sqitch', treat it as 'sqitch help'
IF "%1"=="" IF "%2"=="" GOTO CmdHelp

REM Fail if there are no commands
IF "%1"=="" GOTO CmdFail

REM If the target is remote, then we might escalate
IF "%2"=="alpha" GOTO Remote
IF "%2"=="beta" GOTO Remote
IF "%2"=="live" GOTO Remote
GOTO LocalCmd
:Remote

REM The following commands need ecscalation
REM Most of these make changes to the database
REM 'verify' uses raiserror with log which needs escalation 
IF "%1"=="checkout" GOTO EscalatedCmd
IF "%1"=="deploy" GOTO EscalatedCmd
IF "%1"=="rebase" GOTO EscalatedCmd
IF "%1"=="revert" GOTO EscalatedCmd
IF "%1"=="verify" GOTO EscalatedCmd

GOTO LocalCmd
:EscalatedCmd

REM Use dsmod to modify the user's group 
REM 'klist purge' purges cached Kerberos tickets which ensures that the group change is made
@dsmod group "CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" -addmbr "CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" 
@klist purge
run_sqitch %*
@dsmod group "CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" -rmmbr "CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" 
@klist purge

GOTO End

:LocalCmd
run_sqitch %*

GOTO End


:CmdFail
ECHO Usage: sqitch <command> target
PAUSE
GOTO End


:CmdHelp

run_sqitch help

:End
