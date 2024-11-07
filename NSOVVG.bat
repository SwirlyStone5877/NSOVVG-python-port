@echo    off
SETLOCAL ENABLEDELAYEDEXPANSION
title Not Serious Oscilloscope View Video Generator - by @»ÒπŒHeemin
rem CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
:resetvariables
set "masteraudio=None"
set x_res=1280
set y_res=720
set "fps=60"
set "bitrate=5000k"
set "linemode=p2p"
set "chosenfiles="
REM set "channel1=fuck"

:drawlogo

call :reallogo


:menu
echo 	[44m[97m[O] - Open config file[0m		[44m[97m[S] - Save config file[0m
echo.
echo 	[44m[97m[M] - Choose the master audio[0m	[44m[97m[C] - Choose the audio channels[0m
echo.
echo 	[44m[97m[D] - Change display mode[0m	[44m[97m[F] - Configure the audio channels[0m
echo.
echo 	[44m[97m[X] - Set output resolution, FPS[0m[101m[93m[R] - Render^^![0m
echo.
rem for /l %%i in (1,1,100) do (

set i=1
:channelbrr
	if not "!channel%i%!"=="" (
		call :channelshow
		goto channelbrr
	)
	rem set i=1
	set i=1
rem :forout

rem echo 	[33mChosen master audio: [93m!masteraudio![0m
CHOICE /C OSMCDFXR /N
if /i "!ERRORLEVEL!"=="5" (
		if "!linemode!"=="point" (
		set "linemode=p2p"
	) else if "!linemode!"=="p2p" (
		set "linemode=line"
	) else if "!linemode!"=="line" (
		set "linemode=cline"
	) else if "!linemode!"=="cline" (
		set "linemode=point
	) else (
		set "lmwv1=undefined"
	)
	goto drawlogo
)
if /i "!ERRORLEVEL!"=="7" (
	call :inputbox "Input Grammer: XRESxYRESxFPS (Example: 1280x720x60)" "NSOVVG"
	if not "!input!"=="" (
		for /f "tokens=1,2,3 delims=x" %%a in ("!input!") do (
			if not "%%a"=="" (
				set /a XX=%%a-1
				if {!XX!} == {-1} ( call :errmsg "Invalid number in XRES" ) ELSE ( set x_res=%%a )
			)
			if not "%%b"=="" (
				set /a XX=%%b-1
				if {!XX!} == {-1} ( call :errmsg "Invalid number in YRES" ) ELSE ( set y_res=%%b )
			)
			if not "%%c"=="" (
				set /a XX=%%c-1 
				if {!XX!} == {-1} ( call :errmsg "Invalid number in FPS" ) ELSE ( set fps=%%c )
			)
		)
	)
	goto drawlogo
)
if /i "!ERRORLEVEL!"=="3" (
	for /f "delims=" %%a in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.OpenFileDialog; $f.Filter = 'Audio Files|*.wav;*.mp3'; $f.Multiselect = $false; if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Host $f.FileName } else { Write-Host 'None' }"') do set "selectedFile=%%a"
	IF NOT "!selectedFile!"=="None" set "masteraudio=!selectedFile!"
	goto drawlogo
)
if /i "!ERRORLEVEL!"=="4" (
	set pwshcmd=powershell -NoP -C "[System.Reflection.Assembly]::LoadWithPartialName('System.windows.forms')|Out-Null;$OFD = New-Object System.Windows.Forms.OpenFileDialog;$OFD.Multiselect = $True;$OFD.Filter = 'Audio Files|*.mp3;*.wav';$OFD.InitialDirectory = [Environment]::GetFolderPath('Desktop');$OFD.ShowDialog()|out-null;$OFD.FileNames"

	Set i=0
	for /f "delims=" %%I in ('!pwshcmd!') do (
		Set /A i+=1
		set "channel!i!=%%I"
		set "label!i!=Channel !i!"
		set "amp!i!=2"
		set "color!i!=Yellow"
	)
	if !i! NEQ 0 (
		CALL :clearch
		
	)
	
	goto drawlogo
)

if /i "!ERRORLEVEL!"=="6" (
	if not defined channel1 ( call :errmsg "You need to add the audio channels first" && goto drawlogo )
	call :reallogo
	set i=1
	set "choisenumbers="
	rem pause
	:channelconfig
	rem echo !i!
	rem echo !channel%i%!	xcopychannel%i%
	if not "!channel%i%!"=="" (
		rem set "choisenumbers=!choisenumbers!!i!"
		set "choisenumbers=!choisenumbers!!i!"
		call :channelshow
		rem echo !i!
		rem set "choisenumbers=!choisenumbers!!i!"
		rem set "choisenumbers=!choisenumbers!!chcount!"
		goto channelconfig
	)
	
	echo.
	rem echo !choisenumbers!
	
	CHOICE /C !choisenumbers! /N /M "[0mWhich channel would you like to configure?"
	SET "configch=!ERRORLEVEL!"
	ECHO Which configuration would you like to configure?
	echo 	[44m[97m[L] - Label Text[0m		[44m[97m[A] - Amplification[0m		[44m[97m[C] - Wave Color[0m		[44m[97m[X] - Cancel[0m
	CHOICE /C LACX /N
	if "!ERRORLEVEL!"=="1" (
		call :inputbox "Please Type Label Text for Channel No. !configch!" "NSOVVG"
		if not "!input!"=="" (
			set "label!configch!=!input!"
		)
	)
	if "!ERRORLEVEL!"=="2" (
		call :inputbox "Please Set Amplification for Channel No. !configch!" "NSOVVG"
		if not "!input!"=="" (
			set "amp!configch!=!input!"
		)
	)
	if "!ERRORLEVEL!"=="3" (
		call :inputbox "Please Type Hex Color for Channel No. !configch! (Example: 1CFF73)" "NSOVVG"
		if not "!input!"=="" (
			set "color!configch!=!input!"
			rem set "amp!configch!=!input!"
		)
	)
	
	goto drawlogo
	
	rem :channelconfigout
	
)

IF /I "!ERRORLEVEL!"=="2" (
	for /f "delims=" %%a in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.SaveFileDialog; $f.Filter = 'Config File|*.ini'; $f.Multiselect = $false; if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Host $f.FileName } else { Write-Host 'None' }"') do set "saveFile=%%a"
	IF NOT "!saveFile!"=="None" (
		set i=1
		echo x_res=!x_res!> "!saveFile!"
		echo y_res=!y_res!>> "!saveFile!"
		echo fps=!fps!>> "!saveFile!"
		echo masteraudio=!masteraudio!>> "!saveFile!"
		echo linemode=!linemode!>> "!saveFile!"
		:saveloop
		if not "!channel%i%!"=="" (
			echo channel!i!=!channel%i%!>> "!saveFile!"
			echo label!i!=!label%i%!>> "!saveFile!"
			echo amp!i!=!amp%i%!>> "!saveFile!"
			echo color!i!=!color%i%!>> "!saveFile!"
			Set /A i+=1
			goto saveloop
		)
	)
	goto drawlogo
)
IF /I "!ERRORLEVEL!"=="1" (
	for /f "delims=" %%a in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.OpenFileDialog; $f.Filter = 'Config File|*.ini'; $f.Multiselect = $false; if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Host $f.FileName } else { Write-Host 'None' }"') do set "selectedFile=%%a"
	IF NOT "!selectedFile!"=="None" (
		SET i=0
		CALL :clearch
		for /f "tokens=1,* delims==" %%a in ('type "!selectedFile!"') do (
		set "%%a=%%b"
		)
	)
	goto drawlogo

)

if /i "!ERRORLEVEL!"=="8" (
	if not defined channel1 ( call :errmsg "You need to add the audio channels first" && goto drawlogo )
	if "!masteraudio!"=="None" ( call :errmsg "You need to choose the master audio" && goto drawlogo )
	echo 	[101m[93m[R] - Render^^![0m		[46m[97m[P] - Preview[0m		[44m[97m[X] - Cancel[0m
	CHOICE /C RPX /N
	if /i "!ERRORLEVEL!"=="1" (
		for /f "delims=" %%a in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.SaveFileDialog; $f.Filter = 'Video File|*.mp4'; $f.Multiselect = $false; if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Host $f.FileName } else { Write-Host 'None' }"') do set "saveFile=%%a"
		IF NOT "!saveFile!"=="None" (
			set "ffmpegoutput=!saveFile!"
			set "renderorpreview=2"
			goto render
		)
	)
	if /i "!ERRORLEVEL!"=="2" (
			set "renderorpreview=1"
			goto render
	)
	goto drawlogo
)
rem pause 
PAUSE
@echo off
REM Input routine for batch using VBScript to provide input box
REM Stephen Knight, October 2009, http://www.dragon-it.co.uk/

call :inputbox "Please enter something for me:" "NSOVVG"
echo You entered !Input!

:InputBox
set input=
set heading=%~2
set message=%~1
echo wscript.echo inputbox(WScript.Arguments(0),WScript.Arguments(1)) >"!temp!\input.vbs"
for /f "tokens=* delims=" %%a in ('cscript //nologo "!temp!\input.vbs" "!message!" "!heading!"') do set input=%%a
goto :EOF

:errmsg
echo msgbox "%~1^!",vbOKOnly+vbCritical,"NSOVVG" > "!temp!\error.vbs"
cscript //nologo "!temp!\error.vbs"
goto :EOF

:reallogo
cls
if "!linemode!"=="point" (
	set "lmwv1=.°§'°§.°§'°§.°§'°§.°§"
) else if "!linemode!"=="p2p" (
	set "lmwv1=  /\/\/\/\/\/\/\"
) else if "!linemode!"=="line" (
	set "lmwv1= °„°„°„°„°„°„°„°„°„°„°„°„°„°„"
) else if "!linemode!"=="cline" (
	set "lmwv1=°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ°ﬂ"
) else (
	set "lmwv1=undefined"
)
if "!masteraudio!"=="None" (
	set "mastername=[91mNone"
) else (
	for %%F in (""!masteraudio!"") do set "mastername=[93m"%%~nxF"
)
echo.                                                                        
echo    [1m[97m         ,--.              ,----..                                     	¶Æ¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨[Current Preset]¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶Ø
echo           ,--.'^| .--.--.     /   /   \                         ,----..    	¶≠  [32mChosen master audio: !mastername![97m		¶≠
echo       ,--,:  : ^|/  /    '.  /   .     :       ,---.      ,---./   /   \   	¶≠  [32mVideo resolution:	[93m!x_res! x !y_res![97m		¶≠
echo    ,`--.'`^|  ' ^|  :  /`. / .   /   ;.  \     /__./^|     /__./^|   :     :  	¶≠  [32mFPS:	[93m!fps!FPS[97m				¶≠
echo    ^|   :  :  ^| ;  ^|  ^|--` .   ;   /  ` ;,---.;  ; ^|,---.;  ; .   ^|  ;. /  	¶≠  [32mDisplay Mode: [93m!linemode! !lmwv1![97m	¶≠
echo    :   ^|   \ ^| ^|  :  ;_   ;   ^|  ; \ ; /___/ \  ^| /___/ \  ^| .   ; /--`   	¶≠												¶≠
echo    ^|   : '  '; ^|\  \    `.^|   :  ^| ; ^| \   ;  \ ' \   ;  \ ' ;   ^| ;  __  	¶≠												¶≠
echo    '   ' ;.    ; `----.   .   ^|  ' ' ' :\   \  \: ^|\   \  \: ^|   : ^|.' .' 	¶≠												¶≠
echo    ^|   ^| ^| \   ^| __ \  \  '   ;  \; /  ^| ;   \  ' . ;   \  ' .   ^| '_.' : 	¶≠												¶≠
echo    '   : ^|  ; .'/  /`--'  /\   \  ',  /   \   \   '  \   \   '   ; : \  ^| 	¶≠												¶≠
echo    ^|   ^| '`--' '--'.     /  ;   :    /     \   `  ;   \   `  '   ^| '/  .' 	¶≠												¶≠
echo    '   : ^|       `--'---'    \   \ .'       :   \ ^|    :   \ ^|   :    /   	¶≠												¶≠
echo    ;   ^|.'                    `---`          '---"      '---" \   \ .'    	¶±¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶¨¶∞
echo    '---'                                                       `---`      [0m
echo.             Not Serious Oscilloscope View Video Generator
echo.
goto :EOF

:channelshow
if !i! equ 1 echo	[100m[97mChannels[0m
if "!label%i%!"=="" ( set "displayedlabel=None" ) else ( set "displayedlabel="!label%i%!"" )
echo 	[96mChannel No. !i! [93m"!channel%i%!" && echo [36m	 ¶¶¶°¶°¶° [96mLabel Text: [93m!displayedlabel!		[100m[97m^|^|[0m	[96mAmplification: [93m!amp%i%!		[100m[97m^|^|[0m	[96mWave Color: [93m!color%i%!
set chcount=!i!
rem echo !chcount!
Set /A i+=1

goto :EOF

		:clearch
		Set /A i+=1
		if not "!channel%i%!"=="" (
			set "channel!i!="
			goto clearch
		)
		goto :EOF
		
:render
:: ∏∂Ω∫≈Õ ø¿µø¿ ∆ƒ¿œ (%1)
rem set "masterAudio=%~1"
rem echo on

:: √§≥Œ ø¿µø¿ ∆ƒ¿œµÈ¿ª √≥∏Æ (%2∫Œ≈Õ ≥°±Ó¡ˆ)
set channelCount=0
set H1Count=0
set H2Count=0
set "channelInputs="
set "filterComplex="
set "layout="
set "autosortvaule=4"
set "outer="
set "H1F="
set "H2F="

::USER CONFIG VAULES::
rem set x_res=1280
rem set y_res=720
set "colorvaule=White"
rem set "linemode=p2p"
set "bitrate=5000k"
set "scalemode=lin"
set "gain=4"
set "gpu=h264_qsv"
rem set "fps=60"
::USER CONFIG VAULES_END::
rem @echo on
rem set "beforeshowwaves=volume=!gain![gained"
set stack_num=!chcount!
set /a stack_y_res=y_res / stack_num
set /a remainder=y_res %% stack_num
echo !stack_num!
set /a last_stack_y_res=stack_y_res + remainder
rem set "drawtext=drawtext=text='Channel 3':x=10:y=10:fontsize=24:fontcolor=white"

if !chcount! GTR !autosortvaule! (
	echo AUTO CHANNEL SORTING

	set /a h1number=!chcount! / 2
	set /a hremainder=!chcount! %% 2

	if !hremainder! equ 0 (
		set /a h1number=!chcount! / 2
		set /a h2number=!chcount! / 2
	) else (
		set /a h1number=!chcount! / 2
		set /a h2number=!hremainder! + !h1number!
	)
	echo !h2number! !h1number!
	set /a H1_y_res=y_res / h2number
	set /a H1remainder=y_res %% h2number
	set /a last_H1_y_res=H1_y_res + H1remainder

	set /a H2_y_res=y_res / h1number
	set /a H2remainder=y_res %% h1number
	set /a last_H2_y_res=H2_y_res + H2remainder

	set /a x_reshalf=x_res/2
	rem echo !x_res!
	ECHO H1 : !H1_y_res!, !last_H1_y_res!
	echo H2 : !H2_y_res!, !last_H2_y_res!

)
:loop
rem shift
set /a channelCount+=1
set "beforeshowwaves=volume=!amp%channelCount%![gained"
if !channelCount! gtr !chcount! goto endloop
rem set /a channelCount+=1
set "channelInputs=!channelInputs! -i "!channel%channelCount%!""

set "drawtext=drawtext=text='!label%channelCount%!':x=10:y=10:fontsize=24:fontcolor=white"

if !chcount! GTR !autosortvaule! (

	if !channelCount! LEQ !h2number! (
		set /a H1Count+=1
		if "!H1Count!"=="!h2number!" (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_reshalf!x!last_H1_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];[wave%channelCount%]!drawtext![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H1Count![left];"
		) else (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_reshalf!x!H1_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];[wave%channelCount%]!drawtext![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	) else (
		set /a H2Count+=1
		if "!H2Count!"=="!h1number!" (
				

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_reshalf!x!last_H2_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];[wave%channelCount%]!drawtext![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H2Count![right];"
		) else (

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_reshalf!x!H2_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];[wave%channelCount%]!drawtext![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	)
	
) else (
	if "!channelCount!"=="!chcount!" (
		if !chcount!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![gained%channelCount%];[gained%channelCount%]!drawtext!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];[wave%channelCount%]!drawtext![wave%channelCount%];"
		)
	) else (
		if !chcount!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![gained%channelCount%];[gained%channelCount%]!drawtext!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];[wave%channelCount%]!drawtext![wave%channelCount%];"
		)
	)
	if !chcount!==1 (
		set "layout="
	) else (
		set "layout=!layout![wave%channelCount%]"
	)
)
rem shift
rem set /a i-=1
goto loop

:endloop

echo %channelCount% %i%
:: √÷¡æ √‚∑¬ ∑π¿Ãæ∆øÙ¿ª ¡§¿«
if "!chcount!"=="1" (
	set "layout=!layout!"
	set "outer=-c:v !gpu! -format yuv420p"
) else if !chcount! GTR !autosortvaule! (
	set "filterComplex=!H1F!!H2F!"
	set "layout=!layout![left][right]hstack=inputs=2[v2];"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
) else (
	set "layout=!layout!vstack=inputs=!chcount![v2];"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
)
echo ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% -f nut
:playorrender
rem CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
if /i "!renderorpreview!"=="2" (

	ffmpeg -loglevel quiet -stats -i "!masterAudio!" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% "!ffmpegoutput!"
	REM PAUSE
	
) else if /i "!renderorpreview!"=="1" (

	ffmpeg -loglevel quiet -stats -i "!masterAudio!" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% -f nut - | ffplay - 
	echo ^(Ignore if it said "Conversion failed^!"^)
	REM pause
	
) else (
	echo Aborted.
	exit
)
rem endlocal
goto drawlogo