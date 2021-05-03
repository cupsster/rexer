@echo OFF
cls
echo =============================================================================
echo   REXPaint batch converter v0.1 by Peter Matejovsky - cupsster[at]gmail.com
echo To use this script, place it next to REXPaint executable and files to convert
echo into 'images' folder.
echo =============================================================================
echo ==========! LIMITATIONS - Read this, no joke! !==============================
echo -=# REX Files #=-
echo If '.rx' file name with same name already exist, IT WILL BE OVERWRITTEN without ANY warning!!! Watch out for this!!!!
echo -=# TXT Files #=-
echo Only plain text files are supported glyphs 0~127, no UTF encoding.
echo The width of the image produced will be determined by the longest line in the .txt file, and by default will use black glyphs on a white background.
echo -=# PNG Files #=-
echo File name must include '_WWWxHHH' at the end, where WWW and HHH are the pixel width and height of an individual cell in the image.
echo E.g. a Nethack screenshot using an 8x16 monospaced font should be named something like 'NetHack_8x16'.
echo While the resulting .xp image will properly assign all foreground and background colors, it cannot actually identify glyphs for what they are. 
echo Instead any glyph-containing cell will simply use '?' (in the proper color) to represent a glyph in that location.
echo You can also add the "-uniqueGlyphs" switch to the command line, which instead of representing glyphs as '?', will at least distinguish between glyphs within the image that are different from each other and use a unique glyph to represent each one (but the same unique glyph for those that match).
echo Because this was originally developed to as a roguelike screenshot reader, it will also automatically use '.' to represent the most commonly found glyph in the original image.
echo It is assumed the .png source has no transparency layer.
echo =============================================================================

:getConvertOption
	echo.
	set /p answer=Please select batch operation: [P]ng, [T]xt or [Q]uit?
	if /i "%answer:~,1%" EQU "P" (
		set rexArgument=png
		goto getPngExtra
	)
	if /i "%answer:~,1%" EQU "T" (
		set rexArgument=txt
		goto getCleanupOption
	)
	if /i "%answer:~,1%" EQU "Q" exit /b
	echo Please press [P] for PNG or [T] for TXT or [Q] to Quit
	goto getConvertOption

:getPngExtra
	echo.
	set /p answer=Do you want to use unique glphs (Y/N)?
	if /i "%answer:~,1%" EQU "Y" (
		set /A uniqueGlyphs=1
		goto getCleanupOption
	)
	if /i "%answer:~,1%" EQU "N" goto getCleanupOption
	echo Please press [Y] for Yes or [N] for No
	goto getPngExtra

:getCleanupOption 
	echo.
	echo Processed files can be pulled out to 'Processed' folder after conversion

	echo If you select [Y]es, folder will be created in REXPaint folder with name: 'Processed_YYYYMMDD_HHMMSS'
	echo and procssed files will be moved there. If you select [N]o, files will stay in place.
	echo.

:getCleanupOptionAnswer
	set /p answer=Do you want to move files (Y/N)?
	if /i "%answer:~,1%" EQU "Y" (
		set /A moveFiles=1
		goto editit
	)
	if /i "%answer:~,1%" EQU "N" goto editit
	echo Please press [Y] for Yes or [N] for No
	goto getCleanupOptionAnswer

:editit
echo =============================================================================
set imagesPath=%~dp0images\
echo Expected work path: %imagesPath%
set rexPaint=%~dp0REXPaint.exe
echo Expected RXPaint location: %rexPaint%
echo =============================================================================
echo Starting search for %rexArgument% files...
echo.
set /A numConvertedFiles=0
for /r %imagesPath% %%I in (*.%rexArgument%) DO ( 
	echo Processing: %%~nI%%~xI
	if defined uniqueGlyphs (
		call %rexPaint% -%rexArgument%2xp:%%~nI%%~xI -uniqueGlyphs
	) else (
		call %rexPaint% -%rexArgument%2xp:%%~nI%%~xI
	)
	set /A numConvertedFiles += 1
)

if %numConvertedFiles% EQU 0 ( goto nohingToConvert )

set CUR_YYYY=%date:~10,4%
set CUR_MM=%date:~4,2%
set CUR_DD=%date:~7,2%
set CUR_HH=%time:~0,2%
if %CUR_HH% lss 10 ( set CUR_HH=0%time:~1,1% )

set CUR_NN=%time:~3,2%
set CUR_SS=%time:~6,2%
set CUR_MS=%time:~9,2%
set timestamp=%CUR_YYYY%%CUR_MM%%CUR_DD%_%CUR_HH%%CUR_NN%%CUR_SS%

if defined moveFiles (
	echo =============================================================================
	echo.
	echo Moving converted files out of image directory...
	echo.
	move /-Y %imagesPath%*.%rexArgument% Processed_%timestamp%\
	goto conversionDone
)

:nohingToConvert
	echo There is nothing to convert!
	echo.
	set /p answer=Do you want to start over (Y/N)?
	echo.
   	if /i "%answer:~,1%" EQU "Y" goto getConvertOption
   	if /i "%answer:~,1%" EQU "N" exit /b
   	echo Please press [Y] for Yes or [N] for No to Quit
   	goto nohingToConvert

:conversionDone
echo =============================================================================
echo.
echo     Howdy %username%, your conversion is done. :) Enjoy!
echo.
echo =============================================================================
exit /b
