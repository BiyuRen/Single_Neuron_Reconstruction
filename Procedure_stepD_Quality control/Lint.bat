@echo off
setlocal enabledelayedexpansion

:: Create directories for different stages of the process
mkdir lint 2>nul
mkdir split 2>nul
mkdir join 2>nul

:: Combine all .fnt files in the merge directory into a single file
fnt-join.exe -o join\join.fnt merge\*.fnt

:: Split the combined .fnt file into individual files
fnt-split.exe -o join join\join.fnt

:: Combine the split files starting with '0' into a new file
fnt-join.exe -o join\join2.fnt join\0*.fnt

:: Lint the combined file and save the results to the lint directory
fnt-lint.exe -o lint join\join2.fnt

:: Change directory to split to work with the split files
cd split

:: Process each .fnt file in the lint directory
for %%i in (..\lint\*.fnt) do (
    echo Processing %%i
    echo File name: %%~ni
    fnt-split.exe -o %%~ni ..\lint\%%i
    echo Processed %%i
)

:: Wait for 5 seconds before proceeding
choice /t 5 /d y /n >nul
echo Splitting finished

:: Return to the parent directory
cd ..

:: Rename each .fnt file in the split directory based on the last 10 characters of the last line in the file
for /f "delims=" %%a in ('dir /a-d/b/s "split\"') do (
    set "filePath=%%a"
    for /f "delims=" %%i in ('type "!filePath!"') do (
        set "lastLine=%%i"
    )
    setlocal enabledelayedexpansion
    ren "!filePath!" "!lastLine:~-10!.fnt"
)

:: End of script
endlocal
