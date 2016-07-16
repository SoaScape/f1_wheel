@echo off
SET location="c:\Program Files (x86)\SLIMax Manager"
echo Copying into %location%.
echo.
copy /Y cfg\* %location%\cfg
copy /Y scripts\* %location%\scripts
echo.
echo Done.
echo.
echo.