@echo off
SET script_location="C:\Program Files (x86)\SLIMax Manager Pro\scripts"
SET cfg_location="M:\Documents\My Documents\SLIMax Manager Pro\cfg"
SET diff_location="C:\Program Files (x86)\SLIMax Manager Pro\diff-maps"

echo Copying into %script_location%.
echo.
xcopy /E /Y cfg\* %cfg_location%
xcopy /E /Y scripts\* %script_location%
xcopy /E /Y diff-maps\* %diff_location%
del %script_location%\testharness.lua
echo.
echo Done.
echo.
echo.