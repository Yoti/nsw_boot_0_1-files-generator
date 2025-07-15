@echo off
path=C:\Dev\SDK\mingw\bin;C:\Dev\SDK\mingw\msys\1.0\bin
if "%1" neq "" (
	echo "%~nx1"
	if "%~x1" equ ".c" (
		gcc.exe -static -O2 -s -o "%~dpn1.exe" "%1"
	)
	if "%~x1" equ ".cpp" (
		g++.exe -static -O2 -s -o "%~dpn1.exe" "%1"
	)
	if exist "%~dpn1.exe" strip.exe -s "%~dpn1.exe"
) else (
	for %%f in (*.c) do (
		echo "%%f"
		gcc.exe -static -O2 -s -o "%%~nf.exe" "%%f"
		if exist "%%~nf.exe" strip.exe -s "%%~nf.exe"
	)
	for %%f in (*.cpp) do (
		echo "%%f"
		g++.exe -static -O2 -s -o "%%~nf.exe" "%%f"
		if exist "%%~nf.exe" strip.exe -s "%%~nf.exe"
	)
)
pause