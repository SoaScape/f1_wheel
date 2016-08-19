@echo off
SET location="c:\Program Files (x86)\SLIMax Manager Pro"
echo Copying into %location%.
echo.
xcopy /E /Y cfg\* %location%\cfg
xcopy /E /Y scripts\* %location%\scripts
echo.
echo Done.
echo.
echo.