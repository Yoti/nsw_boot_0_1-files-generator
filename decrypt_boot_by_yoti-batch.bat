@echo off
title Decrypt boot partitions script by Yoti (v20250508)
echo Decrypt boot partitions script by Yoti (v20250508)

if not exist hactool.exe goto hactoolexe
if not exist prod.keys goto prodkeys

echo Wait...
for /d %%d in (??.?.?) do (
	echo %%d
	cd %%d

	for %%f in (????????????????????????????????.nca) do (
		..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%f | find "0100000000000819" >nul && (
			..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%f | find "RomFS" >nul && (
				echo 1_%%~nf [Normal]
				if exist 1_%%~nf rd /s /q 1_%%~nf
				..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nca --romfsdir=1_%%~nf %%f >nul
			)
		)
	)

	for %%f in (????????????????????????????????.nca) do (
		..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%f | find "010000000000081a" >nul && (
			..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%f | find "RomFS" >nul && (
				echo 2_%%~nf [SafeMode]
				if exist 2_%%~nf rd /s /q 2_%%~nf
				..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nca --romfsdir=2_%%~nf %%f >nul
			)
		)
	)

	cd ..
)
goto thisistheend

:hactoolexe
echo Error: hactool.exe is missing!
goto thisistheend
:prodkeys
echo Error: prod.keys is missing!
goto thisistheend

:thisistheend
echo Done!!!
pause