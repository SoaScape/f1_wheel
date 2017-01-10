@echo off
SET script_location="c:\Program Files\SLIMax Manager Pro\scripts"
SET cfg_location="M:\Documents\My Documents\SLIMax Manager Pro\cfg"

echo Copying into %script_location%.
echo.
xcopy /E /Y cfg\* %cfg_location%
xcopy /E /Y scripts\* %script_location%
del %script_location%\testharness.lua
echo.
echo Done.
echo.
echo.