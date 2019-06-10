@ECHO OFF
if not exist D:\Backup md d:\Backup
SET BACKPATH=D:\Backup
ECHO 准备备份数据库
REM 7天一个循环
IF EXIST %BACKPATH%\ONE GOTO ONE
IF EXIST %BACKPATH%\TWO GOTO TWO
IF EXIST %BACKPATH%\THREE GOTO THREE
IF EXIST %BACKPATH%\FOUR GOTO FOUR
IF EXIST %BACKPATH%\FIVE GOTO FIVE
IF EXIST %BACKPATH%\SIX GOTO SIX
IF EXIST %BACKPATH%\SEVEN GOTO SEVEN
ECHO E > %BACKPATH%\ONE

:ONE
del %BACKPATH%\*.* /q
ECHO E > %BACKPATH%\ONE
SET BACKPATH_FULL=%BACKPATH%\01
REN %BACKPATH%\ONE TWO
GOTO BACK

:TWO
SET BACKPATH_FULL=%BACKPATH%\02
REN %BACKPATH%\TWO THREE
GOTO BACK

:THREE
SET BACKPATH_FULL=%BACKPATH%\03
REN %BACKPATH%\THREE FOUR
GOTO BACK

:FOUR
SET BACKPATH_FULL=%BACKPATH%\04
REN %BACKPATH%\FOUR FIVE
GOTO BACK

:FIVE
SET BACKPATH_FULL=%BACKPATH%\05
REN %BACKPATH%\FIVE SIX
GOTO BACK

:SIX
SET BACKPATH_FULL=%BACKPATH%\06
REN %BACKPATH%\SIX SEVEN
GOTO BACK

:SEVEN
SET BACKPATH_FULL=%BACKPATH%\07
REN %BACKPATH%\SEVEN ONE
GOTO BACK

:BACK
EXP LCBYADMIN/LCBY0597ADMIN@XCORCL FILE=%BACKPATH_FULL%.dmp
EXIT

