@echo off
REM FOR /D %%i in (.) do  
REM   if %%i == "java"  
REM     (dir)

REM FOR /D %%i in (.) do cd %%i & dir & cd ..

FOR /F %%i in ('dir /b D:\bitbucket') do echo %%i & cd d:\bitbucket\%%i & git status & git diff
    REM cd %%i 
    REM if %%i NOT '.' && %%i NOT '..' (
        REM echo %%i & 
        REM cd %%i & 
        REM dir & 
        REM git status & 
        REM git diff & 
        REM cd .. )

@echo on 

