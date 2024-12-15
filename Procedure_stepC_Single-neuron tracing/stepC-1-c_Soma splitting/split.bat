@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
set folder=Total somas
fnt-split.exe -o %folder% .\%folder%.fnt
cd !folder!
del J*.fnt
cd ../
for /f "delims=" %%a in ('dir /a-d/b/s "%folder%\"') do ( 
set filePath=%%a
    for /f "delims=" %%i in (!filePath!) do (
          
        set lastLine=%%~i
    ) 
    ren !filePath! !lastLine:~-10!.fnt

)

