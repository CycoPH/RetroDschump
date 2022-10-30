@echo off
@echo Cleaning old build files
rmdir /S out /Q
@echo Creating new folders
mkdir out
@echo ---------------
@echo Building files
:: atasm -Ic:/progs/atari/includes -I./music -odisk/cerebus.xex -lsymbols.dbg theapp.asm
.\bin\atasm.exe -oout\dschump.xex -dORIGINAL_GRAPHICS=0 -dONLY1LEVEL=0 -I"src" -I"src/boot" -I"src/fonts" -I"src/includes" -I"src/levels" -I"src/music" -I"src/sprites" "src/dschump.asm"
if %errorlevel% EQU 0 goto :ok
if not exist cerebus.xex (
	@echo Failed to build cerebus.xex
	goto :stop
)
@echo Something went wrong!
goto :stop
:ok
@echo ---------------
@echo Compressing xex
cd tools
.\PackAtariXex.exe ..\out\dschump.xex
cd ..
copy out\dschump.xex.zx5 out\rdschump.xex

:stop
pause