@echo    off

SETLOCAL ENABLEDELAYEDEXPANSION
title Not Serious Oscilloscope View Video Generator - by @Èñ¹ÎHeemin
rem chcp 949
chcp 949 > nul	
rem CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
:resetvariables
set "masteraudio=None"
set x_res=1280
set y_res=720
set "fps=60"
set "bitrate=5000k"
set "linemode=p2p"
set "chosenfiles="
set "progressbartestpath=!temp!\NSOVVG_displayrendering.bat"
set "progresslogpath=!temp!\NSOVVG_ffmpegprogresslog.log"
del /q !progresslogpath! 
del /q !progressbartestpath! 


echo Detecting your GPU... Please wait!


for /f "tokens=2 delims==" %%G in ('wmic path win32_videocontroller get name /value') do set "gpu_name=%%G"

echo !gpu_name! | find /i "NVIDIA" >nul
if %errorlevel%==0 (
    set "gpu=h264_nvenc"
    goto bfdrawlogo
)

echo !gpu_name! | find /i "Intel" >nul
if %errorlevel%==0 (
    set "gpu=h264_qsv"
    goto bfdrawlogo
)

echo !gpu_name! | find /i "AMD" >nul
if %errorlevel%==0 (
    set "gpu=h264_amf"
    goto bfdrawlogo
)


if not defined gpu set "gpu=libx264"
:bfdrawlogo
rem ecoh 

REM set "channel1=fuck
rem chcp 65001
 echo @echo off> !progressbartestpath!
 echo setlocal enabledelayedexpansion >> !progressbartestpath!
 echo title Rendering... >> !progressbartestpath!
 echo mode 53,7 >> !progressbartestpath!
 echo for /f "tokens=* delims=" %%%%a in ('ffprobe -v error -show_entries format^^=duration -of default^^=noprint_wrappers^^=1:nokey^^=1 "%%~1"') do ( >> !progressbartestpath!
 echo     set decimal_value=%%%%a >> !progressbartestpath!
 echo ) >> !progressbartestpath!
 echo for /f "usebackq tokens=* delims=" %%%%a in (`powershell -command "[math]::Round(%%decimal_value%% * 1000)"`) do ( >> !progressbartestpath!
 echo 	set duration=%%%%a >> !progressbartestpath!
 echo ) >> !progressbartestpath!
 echo :a >> !progressbartestpath!
 echo if not exist "%%~2" goto a >> !progressbartestpath!
 echo set /p ifnone=^<"%%~2" >> !progressbartestpath!
 echo if "^!ifnone^!"=="None" exit /b >> !progressbartestpath!
 echo set "result=" >> !progressbartestpath!
 echo for /f "tokens=2 delims==" %%%%a in ('findstr "out_time_ms" "%%~2"') do ( >> !progressbartestpath!
 echo     set /a last_out_time=%%%%a / 1000 >> !progressbartestpath!
 echo ) >> !progressbartestpath!
 echo if not defined last_out_time goto a >> !progressbartestpath!
 rem echo  >> !progressbartestpath!
 echo set /a percent=(last_out_time*100)/duration >> !progressbartestpath!
 echo set /a display=(last_out_time*50)/duration >> !progressbartestpath!
 echo rem echo ¹éºÐÀ²: %%percent%%%% >> !progressbartestpath!
 echo for /l %%%%i in (1,1,^^!display^^!) do set "result=^!result^![103m [0m" >> !progressbartestpath!
 rem echo  >> !progressbartestpath!
 rem echo :: ³ª¸ÓÁö´Â A·Î Ã¤¿ì±â >> !progressbartestpath!
 echo set /a remaining=50-^^!display^^! >> !progressbartestpath!
 echo for /l %%%%i in (1,1,^^!remaining^^!) do set "result=^!result^![44m [0m" >> !progressbartestpath!
 echo if not defined result goto a >> !progressbartestpath!
 echo cls >> !progressbartestpath!
 echo echo [44m[97m¦®¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¯ >> !progressbartestpath!
 echo echo ¦­   Not Serious Oscilloscope View Video Generator  ¦­ >> !progressbartestpath!
 echo echo ¦­   Rendering: ^^!percent^^!%%%%				   ¦­ >> !progressbartestpath!
 echo echo ¦­                                                  ¦­ >> !progressbartestpath!
 echo echo ¦­^^!result^^![44m[97m¦­ >> !progressbartestpath!
 echo echo ¦±¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦° >> !progressbartestpath!
 echo timeout 1 ^> nul >> !progressbartestpath!
 echo goto a >> !progressbartestpath!
rem  chcp 949
 rem del /q !progresslogpath!
:drawlogo
REM echo !gpu!
call :reallogo


:menu
echo 	[44m[97m[O] - Open config file[0m		[44m[97m[S] - Save config file[0m
rem echo.
echo 	[44m[97m[M] - Choose the master audio[0m	[44m[97m[C] - Choose the audio channels[0m
rem echo.
echo 	[44m[97m[D] - Change display mode[0m	[44m[97m[F] - Configure the audio channels[0m
rem echo.
echo 	[44m[97m[G] - Global configure[0m		[44m[97m[L] - Clear the channels[0m
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
CHOICE /C OSMCDFXRGL /N
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
				if {!XX!} == {-1} ( call :errmsg "Invalid number in XRES" ) ELSE ( set "x_res=%%a" )
			)
			if not "%%b"=="" (
				set /a XX=%%b-1
				if {!XX!} == {-1} ( call :errmsg "Invalid number in YRES" ) ELSE ( set "y_res=%%b" )
			)
			if not "%%c"=="" (
				set /a XX=%%c-1 
				if {!XX!} == {-1} ( call :errmsg "Invalid number in FPS" ) ELSE ( set "fps=%%c" )
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
		set "color!i!=#FFFFFF"
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
		set "choisenumbers=!i!"
		call :channelshow
		rem echo !i!
		rem set "choisenumbers=!choisenumbers!!i!"
		rem set "choisenumbers=!choisenumbers!!chcount!"
		goto channelconfig
	)
	
	echo [0m
	rem echo !choisenumbers!
	
	REM CHOICE /C !choisenumbers! /N /M "[0mWhich channel would you like to configure?"
	:reask
	if defined channel2 (
		SET /P configch=Which channel would you like to configure? 
	) else (
		set configch=1
	)
	echo.
	rem echo aw%configch%fuck
	if not defined channel!configch! call :errmsg "Invalid vaule" && goto reask
	rem SET "configch=!ERRORLEVEL!"
	ECHO Which configuration would you like to configure?
	echo 	[44m[97m[L] - Label Text[0m		[44m[97m[A] - Amplification[0m		[44m[97m[C] - Wave Color[0m		[100m[97m[X] - Cancel[0m
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
		rem call :inputbox "Please Type Hex Color for Channel No. !configch! (Example: 1CFF73)" "NSOVVG"
		for /f "usebackq tokens=*" %%A in (`powershell -command ^
		"Add-Type -AssemblyName System.Windows.Forms; $colorDialog = New-Object System.Windows.Forms.ColorDialog; if ($colorDialog.ShowDialog() -eq 'OK') { $colorDialog.Color.ToArgb().ToString('X8') } else { 'None' }"`) do set "color=%%A"

		if not "!color!"=="None" (
			set "color!configch!=#!color:~2!"
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
	echo 	[101m[93m[R] - Render^^![0m		[46m[97m[P] - Preview[0m		[100m[97m[X] - Cancel[0m
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
if /i "!ERRORLEVEL!"=="9" (
	if not defined channel1 ( call :errmsg "You have no channels to configure" && goto drawlogo )
	set i=0
	echo.
	ECHO [0mWhich configuration would you like to configure globally?
	echo 	[44m[97m[L] - Label Text[0m		[44m[97m[A] - Amplification[0m		[44m[97m[C] - Wave Color[0m		[100m[97m[X] - Cancel[0m
	CHOICE /C LACX /N
	echo.
	if /i "!ERRORLEVEL!"=="1" (
		rem set i=0
		echo Which channel name template do you want?
		echo 	[44m[97m[1] - "Channel No. $"[0m		[44m[97m[2] - "Channel #$"[0m		[44m[97m[3] - Use the name of the file[0m
		echo		[44m[97m[4] - Custom[0m			[44m[97m[5] - Clear[0m			[100m[97m[X] - Cancel[0m
		rem CHOICE /C 12345X /N
		for /f %%A in ('powershell -command "$key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').Character; Write-Host $key"') do set "userInput=%%A"
		if /i "!userInput!"=="5" (
			:labelset1
			Set /A i+=1
			if not "!channel%i%!"=="" (
				set "label!i!="
				goto labelset1
			)
		)
		IF /I "!userInput!"=="1" (
			:labelset2
			Set /A i+=1
			if not "!channel%i%!"=="" (
				set "label!i!=Channel No. !i!"
				goto labelset2
			)
		)
		IF /I "!userInput!"=="2" (
			:labelset3
			Set /A i+=1
			if not "!channel%i%!"=="" (
				set "label!i!=Channel #!i!"
				goto labelset3
			)
		)
		IF /I "!userInput!"=="3" (
			:labelset4
			Set /A i+=1
			if not "!channel%i%!"=="" (
				rem set "label!i!=Channel No. !i!"
				for %%F in ("!channel%i%!") do set "label!i!=%%~nF"
				goto labelset4
			)
		)
		IF /I "!userInput!"=="4" (
			call :inputbox "The following text applies to all channels, the letter $ is assigned to the channel number (Example: CH$ = CH1, CH2, CH3...)" "NSOVVG"
			if not "!input!"=="" (
				rem set labelstr=!input:$=%i%!
				:labelset5
				Set /A i+=1
				set labelstr=!input:$=%i%!
				if not "!channel%i%!"=="" (
					set "label!i!=!labelstr!"
					goto labelset5
				)
			)
		)
	)
	if "!ERRORLEVEL!"=="2" (
		call :inputbox "Please Set Amplification for All of Channels" "NSOVVG"
		if not "!input!"=="" (
			rem set "amp!configch!=!input!"
			:labelset6
				Set /A i+=1
				rem set labelstr=!input:$=%i%!
				if not "!channel%i%!"=="" (
					set "amp!i!=!input!"
					goto labelset6
				)
		)
	)
	if "!ERRORLEVEL!"=="3" (
		rem call :inputbox "Please Type Hex Color for Channel No. !configch! (Example: 1CFF73)" "NSOVVG"
		for /f "usebackq tokens=*" %%A in (`powershell -command ^
		"Add-Type -AssemblyName System.Windows.Forms; $colorDialog = New-Object System.Windows.Forms.ColorDialog; if ($colorDialog.ShowDialog() -eq 'OK') { $colorDialog.Color.ToArgb().ToString('X8') } else { 'None' }"`) do set "color=%%A"

		if not "!color!"=="None" (
			rem set "color!configch!=#!color:~2!"
			:labelset7
				Set /A i+=1
				rem set labelstr=!input:$=%i%!
				if not "!channel%i%!"=="" (
					rem set "amp!i!=!input!"
					set "color!i!=#!color:~2!"
					goto labelset7
				)
		)
	)
		goto drawlogo
)
if /i "!ERRORLEVEL!"=="10" (
	if not defined channel1 ( call :errmsg "You have no channels to clear" && goto drawlogo )
	SET i=0
	call :MsgBox "You imported a lot of channels, are you sure to clear everything?"  "VBYesNo+VBQuestion" "NSOVVG"
	REM echo !errorlevel!
	REM pause
	if "!errorlevel!"=="6" CALL :clearch

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

:MsgBox prompt type title
 rem setlocal enableextensions
 set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
 >"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
 set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
 rem endlocal & exit /b %exitCode%
 REM goto :EOF
 exit /b %exitCode%
 
:reallogo
cls
if "!linemode!"=="point" (
	set "lmwv1=.¡¤'¡¤.¡¤'¡¤.¡¤'¡¤.¡¤"
) else if "!linemode!"=="p2p" (
	set "lmwv1=  /\/\/\/\/\/\/\"
) else if "!linemode!"=="line" (
	set "lmwv1= ¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã¡ã"
) else if "!linemode!"=="cline" (
	set "lmwv1=¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß¡ß"
) else (
	set "lmwv1=undefined"
)
if "!masteraudio!"=="None" (
	set "mastername=[91mNone"
) else (
	for %%F in ("!masteraudio!") do set "mastername=[93m"%%~nxF""
)
echo [90mNSOVVG Version v1.0.1[0m
echo    [1m[97m         ,--.              ,----..                                     	¦®¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬[Current Settings]¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¯
echo           ,--.'^| .--.--.     /   /   \                         ,----..    	¦­  [32mChosen Master Audio: !mastername![97m		¦­
echo       ,--,:  : ^|/  /    '.  /   .     :       ,---.      ,---./   /   \   	¦­  [32mVideo Resolution:	[93m!x_res! x !y_res![97m		¦­
echo    ,`--.'`^|  ' ^|  :  /`. / .   /   ;.  \     /__./^|     /__./^|   :     :  	¦­  [32mFPS:			[93m!fps!FPS[97m				¦­
echo    ^|   :  :  ^| ;  ^|  ^|--` .   ;   /  ` ;,---.;  ; ^|,---.;  ; .   ^|  ;. /  	¦­  [32mDisplay Mode: [93m!linemode! !lmwv1![97m	¦­
echo    :   ^|   \ ^| ^|  :  ;_   ;   ^|  ; \ ; /___/ \  ^| /___/ \  ^| .   ; /--`   	¦­  												¦­
echo    ^|   : '  '; ^|\  \    `.^|   :  ^| ; ^| \   ;  \ ' \   ;  \ ' ;   ^| ;  __  	¦­												¦­
echo    '   ' ;.    ; `----.   .   ^|  ' ' ' :\   \  \: ^|\   \  \: ^|   : ^|.' .' 	¦­												¦­
echo    ^|   ^| ^| \   ^| __ \  \  '   ;  \; /  ^| ;   \  ' . ;   \  ' .   ^| '_.' : 	¦­												¦­
echo    '   : ^|  ; .'/  /`--'  /\   \  ',  /   \   \   '  \   \   '   ; : \  ^| 	¦­												¦­
echo    ^|   ^| '`--' '--'.     /  ;   :    /     \   `  ;   \   `  '   ^| '/  .' 	¦­												¦­
echo    '   : ^|       `--'---'    \   \ .'       :   \ ^|    :   \ ^|   :    /   	¦­												¦­
echo    ;   ^|.'                    `---`          '---"      '---" \   \ .'    	¦±¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦¬¦°
echo    '---'                                                       `---`      [0m
echo.             Not Serious Oscilloscope View Video Generator
echo.

goto :EOF

:channelshow
if !i! equ 1 echo	[100m[97mChannels[0m
if "!label%i%!"=="" ( set "displayedlabel=[91mNone" ) else ( set "displayedlabel="!label%i%!"" )
echo 	[96mChannel No. !i! [93m"!channel%i%!" && echo [36m	 ¦¦¦¡¦¡¦¡ [96mLabel Text: [93m!displayedlabel!		[100m[97m^|^|[0m	[96mAmplification: [93m!amp%i%!		[100m[97m^|^|[0m	[96mWave Color: [93m!color%i%!
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
:: ¸¶½ºÅÍ ¿Àµð¿À ÆÄÀÏ (%1)
rem set "masterAudio=%~1"
rem echo on

:: Ã¤³Î ¿Àµð¿À ÆÄÀÏµéÀ» Ã³¸® (%2ºÎÅÍ ³¡±îÁö)
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
rem set "gpu=libx264"
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
:: ÃÖÁ¾ Ãâ·Â ·¹ÀÌ¾Æ¿ôÀ» Á¤ÀÇ
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
REM echo ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% -f nut
:playorrender
rem CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
if /i "!renderorpreview!"=="2" (
	del /q !progresslogpath!
	start conhost !progressbartestpath! "!masterAudio!" "!progresslogpath!"
	REM echo conhost !progressbartestpath! "!masterAudio!" "!progresslogpath!"
	ffmpeg -progress !progresslogpath! -loglevel quiet -stats -i "!masterAudio!" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% "!ffmpegoutput!"
	REM PAUSE
	echo None> !progresslogpath!
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
