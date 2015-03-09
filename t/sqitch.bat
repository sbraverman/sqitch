@ECHO OFF
IF "%1"=="" IF "%2"=="" GOTO CmdHelp
IF "%1"=="" GOTO CmdFail

IF "%2"=="alpha" GOTO Remote
IF "%2"=="beta" GOTO Remote
IF "%2"=="live" GOTO Remote
IF "%2"=="dev" GOTO LocalCmd
IF "%2"=="test" GOTO LocalCmd
IF "%2"=="" GOTO LocalCmd
GOTO TargetFail
:Remote

IF "%1"=="checkout" GOTO EscalatedCmd
IF "%1"=="deploy" GOTO EscalatedCmd
IF "%1"=="rebase" GOTO EscalatedCmd
IF "%1"=="revert" GOTO EscalatedCmd
IF "%1"=="verify" GOTO EscalatedCmd

GOTO LocalCmd
:EscalatedCmd


@dsmod group "CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" -addmbr "CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" 
@klist purge
run_sqitch %1 %2
@dsmod group "CN=Informatics Systems Admins, OU=Informatics Service Accounts, OU=Service Accounts, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" -rmmbr "CN=%USERNAME%, OU=Informatics Team, OU=Unmanaged Users, OU=Users, OU=SDHIS, DC=sdhc, DC=xsdhis, DC=nhs, DC=uk" 
@klist purge

GOTO End

:LocalCmd
run_sqitch %1 %2

GOTO End


:CmdFail
ECHO Usage: sqitch <command> target
PAUSE
GOTO End

:TargetFail
ECHO Usage: Invalid target
PAUSE
GOTO End


:CmdHelp

run_sqitch help

:End