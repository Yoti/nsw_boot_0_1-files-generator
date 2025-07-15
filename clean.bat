@echo off
for /d %%d in (??.?.*) do (
	rd /s /q %%d
)
del /q *.zip