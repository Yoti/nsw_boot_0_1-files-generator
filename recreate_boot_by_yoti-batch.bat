@echo off
title Recreate boot partitions script by Yoti (v20250508)
echo Recreate boot partitions script by Yoti (v20250508)

if not exist hactool.exe goto hactoolexe
if not exist hextool.exe goto hextoolexe
if not exist prod.keys goto prodkeys

echo Wait...
for /d %%d in (??.?.?) do (
	echo %%d
	cd %%d

	for %%i in (*.nca) do (
		..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%i | find "0100000000000819" >nul && (
			..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%i | find "RomFS" >nul && (
				echo 1_%%~ni [Normal]
				if exist 1_%%~ni rd /s /q 1_%%~ni
				..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nca --romfsdir=1_%%~ni %%i >nul

				if exist BOOT0_ERISTA del /q BOOT0_ERISTA
				..\hextool.exe new $400000 %cd%\%%d\BOOT0_ERISTA >nul
				..\hextool.exe insert 0 1_%%~ni\nx\bct %cd%\%%d\BOOT0_ERISTA >nul
				..\hextool.exe insert $8000 1_%%~ni\nx\bct %cd%\%%d\BOOT0_ERISTA >nul
				..\hextool.exe insert $100000 1_%%~ni\nx\package1 %cd%\%%d\BOOT0_ERISTA >nul
				..\hextool.exe insert $140000 1_%%~ni\nx\package1 %cd%\%%d\BOOT0_ERISTA >nul

				if exist BOOT0_MARIKO del /q BOOT0_MARIKO
				..\hextool.exe new $400000 %cd%\%%d\BOOT0_MARIKO >nul
				..\hextool.exe insert 0 1_%%~ni\a\bct %cd%\%%d\BOOT0_MARIKO >nul
				..\hextool.exe insert $8000 1_%%~ni\a\bct %cd%\%%d\BOOT0_MARIKO >nul
				..\hextool.exe insert $100000 1_%%~ni\a\package1 %cd%\%%d\BOOT0_MARIKO >nul
				..\hextool.exe insert $140000 1_%%~ni\a\package1 %cd%\%%d\BOOT0_MARIKO >nul

				if exist 1_%%~ni rd /s /q 1_%%~ni
			)
		)
	)

	for %%i in (*.nca) do (
		..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%i | find "010000000000081a" >nul && (
			..\hactool.exe -i -k ..\prod.keys --disablekeywarns -t nca %%i | find "RomFS" >nul && (
				echo 2_%%~ni [SafeMode]
				if exist 2_%%~ni rd /s /q 2_%%~ni
				..\hactool.exe -x -k ..\prod.keys --disablekeywarns -t nca --romfsdir=2_%%~ni %%i >nul

				..\hextool.exe insert $4000 2_%%~ni\nx\bct %cd%\%%d\BOOT0_ERISTA >nul
				..\hextool.exe insert $C000 2_%%~ni\nx\bct %cd%\%%d\BOOT0_ERISTA >nul

				..\hextool.exe insert $4000 2_%%~ni\a\bct %cd%\%%d\BOOT0_MARIKO >nul
				..\hextool.exe insert $C000 2_%%~ni\a\bct %cd%\%%d\BOOT0_MARIKO >nul

				if exist BOOT1_ERISTA del /q BOOT1_ERISTA
				..\hextool.exe new $400000 %cd%\%%d\BOOT1_ERISTA >nul
				..\hextool.exe insert 0 2_%%~ni\nx\package1 %cd%\%%d\BOOT1_ERISTA >nul
				..\hextool.exe insert $40000 2_%%~ni\nx\package1 %cd%\%%d\BOOT1_ERISTA >nul

				if exist BOOT1_MARIKO del /q BOOT1_MARIKO
				..\hextool.exe new $400000 %cd%\%%d\BOOT1_MARIKO >nul
				..\hextool.exe insert 0 2_%%~ni\a\package1 %cd%\%%d\BOOT1_MARIKO >nul
				..\hextool.exe insert $40000 2_%%~ni\a\package1 %cd%\%%d\BOOT1_MARIKO >nul

				if exist 2_%%~ni rd /s /q 2_%%~ni
			)
		)
	)

	cd ..
)
goto thisistheend

:hactoolexe
echo Error: hactool.exe is missing!
goto thisistheend
:hextoolexe
echo Error: hextool.exe is missing!
goto thisistheend
:prodkeys
echo Error: prod.keys is missing!
goto thisistheend

:thisistheend
echo Done!!!
pause