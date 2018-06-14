@echo off
SET script_location="C:\Program Files\SLIMax Manager Pro\scripts"
SET cfg_location="C:\Users\mike\Documents\SLIMax Manager Pro\cfg"
SET autocfg_location="C:\Program Files\SLIMax Manager Pro\auto-cfg"

echo Copying into %script_location%.
echo.
xcopy /E /Y cfg\* %cfg_location%
xcopy /E /Y scripts\* %script_location%
xcopy /E /Y auto-cfg\* %autocfg_location%
del %script_location%\testharness.lua
echo.
echo Done.
echo.
echo.