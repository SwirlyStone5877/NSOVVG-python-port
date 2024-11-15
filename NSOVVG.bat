@echo    off

SETLOCAL ENABLEDELAYEDEXPANSION
title Not Serious Oscilloscope View Video Generator - by @희민Heemin
rem chcp 949
chcp 949 > nul	
rem CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
:resetvariables
set "masteraudio=None"
set "bgimage=None"
set x_res=1280
set y_res=720
set "fps=60"
set "bitrate=5000k"
set "linemode=p2p"
set "chosenfiles="
set "progressbartestpath=!temp!\NSOVVG_displayrendering.bat"
set "progresslogpath=!temp!\NSOVVG_ffmpegprogresslog.log"
set "fontpickerpath=!temp!\fontPicker.ps1"
set "numberboxpath=!temp!\numberBox.ps1"
set "reorderboxpath=!temp!\reorder.ps1"
set "dffont=Arial"
set "displayfont=Arial                  "
set "sizefont=14"
set "colorfont=#FFFFFF"
del /q !progresslogpath! 
del /q !progressbartestpath! 
del /q !reorderboxpath!


rem echo Detecting your GPU... Please wait!
echo Creating external scripts... Please wait!

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
 echo set /a percent=(last_out_time*100)/duration >> !progressbartestpath!
 echo set /a display=(last_out_time*50)/duration >> !progressbartestpath!
 echo rem echo 백분율: %%percent%%%% >> !progressbartestpath!
 echo for /l %%%%i in (1,1,^^!display^^!) do set "result=^!result^![103m [0m" >> !progressbartestpath!
 echo set /a remaining=50-^^!display^^! >> !progressbartestpath!
 echo for /l %%%%i in (1,1,^^!remaining^^!) do set "result=^!result^![44m [0m" >> !progressbartestpath!
 echo if not defined result goto a >> !progressbartestpath!
 echo cls >> !progressbartestpath!
 echo echo [44m[97m┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ >> !progressbartestpath!
 echo echo ┃   Not Serious Oscilloscope View Video Generator  ┃ >> !progressbartestpath!
 echo echo ┃   Rendering: ^^!percent^^!%%%%				   ┃ >> !progressbartestpath!
 echo echo ┃                                                  ┃ >> !progressbartestpath!
 echo echo ┃^^!result^^![44m[97m┃ >> !progressbartestpath!
 echo echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛ >> !progressbartestpath!
 echo timeout 1 ^> nul >> !progressbartestpath!
 echo goto a >> !progressbartestpath!
 
echo Add-Type -AssemblyName System.Windows.Forms > !reorderboxpath!
echo Add-Type -AssemblyName System.Drawing >> !reorderboxpath!


echo $channels = @^(^) >> !reorderboxpath!
echo for ^($i = 1; $true; $i++^) { >> !reorderboxpath!
echo     $varName = "channel$i" >> !reorderboxpath!
echo     $value = [Environment]::GetEnvironmentVariable^($varName^) >> !reorderboxpath!
echo     if ^($null -eq $value^) { break } >> !reorderboxpath!
echo     $channels += $value >> !reorderboxpath!
echo } >> !reorderboxpath!


echo $form = New-Object System.Windows.Forms.Form >> !reorderboxpath!
echo $form.Text = "Reorder Channels" >> !reorderboxpath!
echo $form.Width = 800 >> !reorderboxpath!
echo $form.Height = 300 >> !reorderboxpath!
echo $form.StartPosition = 'CenterScreen' >> !reorderboxpath!


echo $listBox = New-Object System.Windows.Forms.ListBox >> !reorderboxpath!
echo $listBox.Location = New-Object System.Drawing.Point^(10, 10^) >> !reorderboxpath!
echo $listBox.Size = New-Object System.Drawing.Size^(700, 200^) >> !reorderboxpath!
echo $listBox.SelectionMode = 'One' >> !reorderboxpath!
echo $listBox.Items.AddRange^($channels^) >> !reorderboxpath!
echo $form.Controls.Add^($listBox^) >> !reorderboxpath!


echo $btnUp = New-Object System.Windows.Forms.Button >> !reorderboxpath!
echo $btnUp.Text = "Up" >> !reorderboxpath!
echo $btnUp.Location = New-Object System.Drawing.Point^(710, 30^) >> !reorderboxpath!
echo $btnUp.Add_Click^({ >> !reorderboxpath!
echo     $selectedIndex = $listBox.SelectedIndex >> !reorderboxpath!
echo     if ^($selectedIndex -gt 0^) { >> !reorderboxpath!
echo         # 항목을 위로 이동 >> !reorderboxpath!
echo         $temp = $listBox.Items[$selectedIndex] >> !reorderboxpath!
echo         $listBox.Items[$selectedIndex] = $listBox.Items[$selectedIndex - 1] >> !reorderboxpath!
echo         $listBox.Items[$selectedIndex - 1] = $temp >> !reorderboxpath!
echo         $listBox.SelectedIndex = $selectedIndex - 1 >> !reorderboxpath!
echo     } >> !reorderboxpath!
echo }^) >> !reorderboxpath!
echo $form.Controls.Add^($btnUp^) >> !reorderboxpath!


echo $btnDown = New-Object System.Windows.Forms.Button >> !reorderboxpath!
echo $btnDown.Text = "Down" >> !reorderboxpath!
echo $btnDown.Location = New-Object System.Drawing.Point^(710, 70^) >> !reorderboxpath!
echo $btnDown.Add_Click^({ >> !reorderboxpath!
echo     $selectedIndex = $listBox.SelectedIndex >> !reorderboxpath!
echo     if ^($selectedIndex -lt $listBox.Items.Count - 1^) { >> !reorderboxpath!
echo         # 항목을 아래로 이동 >> !reorderboxpath!
echo         $temp = $listBox.Items[$selectedIndex] >> !reorderboxpath!
echo         $listBox.Items[$selectedIndex] = $listBox.Items[$selectedIndex + 1] >> !reorderboxpath!
echo         $listBox.Items[$selectedIndex + 1] = $temp >> !reorderboxpath!
echo         $listBox.SelectedIndex = $selectedIndex + 1 >> !reorderboxpath!
echo     } >> !reorderboxpath!
echo }^) >> !reorderboxpath!
echo $form.Controls.Add^($btnDown^) >> !reorderboxpath!


echo $btnOK = New-Object System.Windows.Forms.Button >> !reorderboxpath!
echo $btnOK.Text = "OK" >> !reorderboxpath!
echo $btnOK.Location = New-Object System.Drawing.Point^(100, 220^) >> !reorderboxpath!
echo $btnOK.Add_Click^({ >> !reorderboxpath!
echo     $newOrder = $listBox.Items >> !reorderboxpath!
echo     # 새로운 순서 출력 >> !reorderboxpath!
echo     foreach ^($channel in $newOrder^) { >> !reorderboxpath!
echo         Write-Host $channel >> !reorderboxpath!
echo     } >> !reorderboxpath!
echo     $form.Close^(^) >> !reorderboxpath!
echo }^) >> !reorderboxpath!
echo $form.Controls.Add^($btnOK^) >> !reorderboxpath!


echo $btnCancel = New-Object System.Windows.Forms.Button >> !reorderboxpath!
echo $btnCancel.Text = "Cancel" >> !reorderboxpath!
echo $btnCancel.Location = New-Object System.Drawing.Point^(200, 220^) >> !reorderboxpath!
echo $btnCancel.Add_Click^({ >> !reorderboxpath!
echo     Write-Host "None" >> !reorderboxpath!
echo     $form.Close^(^) >> !reorderboxpath!
echo }^) >> !reorderboxpath!
echo $form.Controls.Add^($btnCancel^) >> !reorderboxpath!


echo $form.Add_Shown^({ $form.Activate^(^) }^) >> !reorderboxpath!
echo [void]$form.ShowDialog^(^) >> !reorderboxpath!
rem echo 
REM set tempScript=%temp%\fontPicker.ps1

call :fontpickercreate
rem  chcp 949
 rem del /q !progresslogpath!
:drawlogo
REM echo !gpu!
call :reallogo


:menu
echo 	[100m[97m[7m[O][27m - Open config file[0m		[100m[97m[7m[S][27m - Save config file[0m
rem echo.
echo 	[43m[97m[7m[M][27m - Choose the master audio[0m	[44m[97m[7m[C][27m - Choose the audio channels[0m
rem echo.
echo 	[44m[97m[7m[D][27m - Change display mode[0m	[104m[97m[7m[F][27m - Configure the audio channels[0m
rem echo.
echo 	[44m[97m[7m[G][27m - Global configuration[0m	[41m[34m[7m[L][27m - Clear the channels[0m
echo 	[45m[97m[7m[T][27m - Font configuration[0m	[45m[97m[7m[V][27m - Other video configuration[0m
echo 	[44m[97m[7m[X][27m - Set output resolution, FPS[0m[101m[93m[7m[R][27m - Render^^![0m
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
CHOICE /C OSMCDFXRGLTV /N
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
		REM call :inputbox "Please Set Amplification for Channel No. !configch!" "NSOVVG"
		call :createnumberbox 50 !amp%configch%! "Please Set Amplification for Channel No. !configch!" 1
		if not "!selectedNumber!"=="None" (
			set "amp!configch!=!selectedNumber!"
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
		echo dffont=!dffont!>> "!saveFile!"
		echo sizefont=!sizefont!>> "!saveFile!"
		echo colorfont=!colorfont!>> "!saveFile!"
		echo bgimage=!bgimage!>> "!saveFile!"
		echo bitrate=!bitrate!>> "!saveFile!"
		
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
	echo 	[44m[97m[L] - Label Text[0m		[44m[97m[A] - Amplification[0m		[44m[97m[C] - Wave Color[0m
	echo 	[44m[97m[R] - Reorder the channels[0m					[100m[97m[X] - Cancel[0m
	CHOICE /C LACXR /N
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
		rem call :inputbox "Please Set Amplification for All of Channels" "NSOVVG"
		call :createnumberbox 50 !amp1! "Please Set Amplification" 2

		rem if not "!input!"=="" (
		if not "!selectedNumber!"=="None" (

		:labelset6
			Set /A i+=1
			if not "!channel%i%!"=="" (
				set "amp!i!=!selectedNumber!"
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
	IF "!ERRORLEVEL!"=="5" (
	set i=1
	for /f "tokens=*" %%A in ('powershell -ExecutionPolicy Bypass -File "!reorderboxpath!"') do (
		set "output=%%A"
		if "!output!" neq "None" (
			set "channel!i!=!output!"
			set /a i+=1
			rem echo Reordered channel: !output!
			
		)
	)
rem pause
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

if /i "!ERRORLEVEL!"=="11" (
ECHO [101m[97m[1m[WARNING] Nothing is supported other than "Font selection", "Font color", and "Font size".
echo [WARNING] The font color keeps being reset to black, so please set it again.[0m
	call :createfontpicker
	for /f "tokens=1,2 delims==" %%a in ('powershell -ExecutionPolicy Bypass -File "!fontpickerpath!"') do (
		if "%%a"=="Canceled" goto drawlogo
		if "%%a"=="FontName" set "dffont=%%b"
		if "%%a"=="FontSize" set "sizefont=%%b"
		if "%%a"=="FontColor" set "colorfont=%%b"
	)
	ECHO WScript.Echo Len^( WScript.Arguments^(0^) ^) > "!temp!\getlength.vbs"
	for /f "tokens=*" %%a in ('cscript //nologo "!temp!\getlength.vbs" "!dffont!"') do set strLen=%%a
	del /q "!temp!\getlength.vbs"
	if !strLen! geq 23 (
		set "displayfont=!dffont!"
	) else (
		set /a remainLen=23-!strLen!
		set "fillString="
		for /l %%i in (1,1,!remainLen!) do set "fillString=!fillString! "
		set "displayfont=!dffont!!fillString!"
	)
		
	GOTO drawlogo
)

if /i "!ERRORLEVEL!"=="12" (
	echo.
	ECHO [0mWhich configuration would you like to configure?
	echo 	[44m[97m[I] - Background Image / Video[0m		[44m[97m[C] - Background Color[0m		[100m[97m[X] - Cancel[0m
	CHOICE /C BIXC /N
	echo.
	if /i "!ERRORLEVEL!"=="2" (
		for /f "delims=" %%a in ('powershell -command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $f = New-Object System.Windows.Forms.OpenFileDialog; $f.Filter = 'Picture Files|*.png;*.jpg;*.mp4;*.jpeg;*.avi'; $f.Multiselect = $false; if ($f.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) { Write-Host $f.FileName } else { Write-Host 'None' }"') do set "selectedFile=%%a"
		IF NOT "!selectedFile!"=="None" set "bgimage=!selectedFile!"
		rem goto drawlogo
	)
	IF /I "!ERRORLEVEL!"=="4" (
		for /f "usebackq tokens=*" %%A in (`powershell -command ^
			"Add-Type -AssemblyName System.Windows.Forms; $colorDialog = New-Object System.Windows.Forms.ColorDialog; if ($colorDialog.ShowDialog() -eq 'OK') { $colorDialog.Color.ToArgb().ToString('X8') } else { 'None' }"`) do set "color=%%A"

		if not "!color!"=="None" set "bgimage=#!color:~2!"
	)
	IF /I "!ERRORLEVEL!"=="1" (
		call :createnumberbox 100000 !bitrate:~0,-1! "Please set the bitrate of the video. (kbps)" 100
		rem for /f "usebackq delims=" %%i in (`powershell -NoProfile -ExecutionPolicy Bypass -File "!numberboxpath!"`) do (
		rem 	set selectedNumber=%%i
		rem )
		if not "!selectedNumber!"=="None" set "bitrate=!selectedNumber!k"
	)
	rem 
	goto drawlogo
)
rem pause 
echo [91mIf you are seeing this message, there is a major bug in this script. Go ahead and tell the developers about this! This stupid script doesn't generate any debug logs, but you don't lose anything \_(쓰)_/[0m
PAUSE
exit
REM Input routine for batch using VBScript to provide input box
REM Stephen Knight, October 2009, http://www.dragon-it.co.uk/

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
DEL /Q "!temp!\error.vbs"
goto :EOF

:MsgBox prompt type title
 rem setlocal enableextensions
 set "tempFile=!temp!\%~nx0.%random%%random%%random%vbs.tmp"
 >"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
 set "exitCode=!errorlevel!" & del "!tempFile!" >nul 2>nul

 exit /b !exitCode!
 
:reallogo
cls
if "!linemode!"=="point" (
	set "lmwv1=.·'·.·'·.·'·.·"
) else if "!linemode!"=="p2p" (
	set "lmwv1=  /\/\/\/\/\/\/\"
) else if "!linemode!"=="line" (
	set "lmwv1= ▲▲▲▲▲▲▲▲▲▲▲▲▲▲"
) else if "!linemode!"=="cline" (
	set "lmwv1=◆◆◆◆◆◆◆◆◆◆◆◆◆◆"
) else (
	set "lmwv1=undefined"
)
if "!masteraudio!"=="None" (
	set "mastername=[91mNone"
) else (
	for %%F in ("!masteraudio!") do set "mastername=[93m"%%~nxF""
)

if "!bgimage!"=="None" (
	set "imagename=[32mBackground Image:	[93m[91mNone[97m"
) else if "!bgimage:~0,1!"=="#" (
	set "imagename=[32mBackground Color:	[93m!bgimage![97m"
) else (
	for %%F in ("!bgimage!") do set "imagename=[32mBackground Image:	[93m"%%~nxF"[97m"
)
echo [90mNSOVVG Version v1.0.2[0m
echo    [1m[97m         ,--.              ,----..                                     	┏━━━━━━━━━━[Current Settings]━━━━━━━━━━┓
echo           ,--.'^| .--.--.     /   /   \                         ,----..    	┃  [32mChosen Master Audio: !mastername![97m		┃
echo       ,--,:  : ^|/  /    '.  /   .     :       ,---.      ,---./   /   \   	┃  [32mVideo Resolution:	[93m!x_res! x !y_res![97m		┃
echo    ,`--.'`^|  ' ^|  :  /`. / .   /   ;.  \     /__./^|     /__./^|   :     :  	┃  [32mFPS:			[93m!fps!FPS[97m				┃
echo    ^|   :  :  ^| ;  ^|  ^|--` .   ;   /  ` ;,---.;  ; ^|,---.;  ; .   ^|  ;. /  	┃  !imagename!		┃
echo    :   ^|   \ ^| ^|  :  ;_   ;   ^|  ; \ ; /___/ \  ^| /___/ \  ^| .   ; /--`   	┃  [32mDisplay Mode: [93m!linemode! !lmwv1![97m	┃
echo    ^|   : '  '; ^|\  \    `.^|   :  ^| ; ^| \   ;  \ ' \   ;  \ ' ;   ^| ;  __  	┃  [32mChosen Font:	[93m!displayfont![97m┃
echo    '   ' ;.    ; `----.   .   ^|  ' ' ' :\   \  \: ^|\   \  \: ^|   : ^|.' .' 	┃  [32mFont Size:	[93m!sizefont![97m											┃
echo    ^|   ^| ^| \   ^| __ \  \  '   ;  \; /  ^| ;   \  ' . ;   \  ' .   ^| '_.' : 	┃  [32mFont Color:	[93m!colorfont![97m												┃
echo    '   : ^|  ; .'/  /`--'  /\   \  ',  /   \   \   '  \   \   '   ; : \  ^| 	┃												┃
echo    ^|   ^| '`--' '--'.     /  ;   :    /     \   `  ;   \   `  '   ^| '/  .' 	┃												┃
echo    '   : ^|       `--'---'    \   \ .'       :   \ ^|    :   \ ^|   :    /   	┃												┃
echo    ;   ^|.'                    `---`          '---"      '---" \   \ .'    	┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo    '---'                                                       `---`      [0m
echo.             Not Serious Oscilloscope View Video Generator
echo.

goto :EOF

:channelshow
if !i! equ 1 echo	[100m[97mChannels[0m
if "!label%i%!"=="" ( set "displayedlabel=[91mNone" ) else ( set "displayedlabel="!label%i%!"" )
for %%F in ("!channel%i%!") do set "displaych=%%~nxF"
echo 	[96mChannel No. !i! [93m"!displaych!" && echo [36m	 └─── [96mLabel Text: [93m!displayedlabel!		[100m[97m^|^|[0m	[96mAmplification: [93m!amp%i%!		[100m[97m^|^|[0m	[96mWave Color: [93m!color%i%!
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
		
:createfontpicker
echo Add-Type -AssemblyName System.Windows.Forms > !fontpickerpath!
echo $fontDialog = New-Object System.Windows.Forms.FontDialog >> !fontpickerpath!

echo $fontDialog.ShowColor = $true >> !fontpickerpath!

echo $defaultFont = New-Object System.Drawing.Font("!dffont!", !sizefont!, [System.Drawing.FontStyle]::Regular) >> !fontpickerpath!
echo $fontDialog.Font = $defaultFont >> !fontpickerpath!

echo if ($fontDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK^) { >> !fontpickerpath!
echo Write-Host "FontName=$($fontDialog.Font.Name)" >> !fontpickerpath!
echo Write-Host "FontSize=$([int]$fontDialog.Font.Size)" >> !fontpickerpath!
rem echo Write-Host "FontColor=$($fontDialog.Color)" >> !fontpickerpath!
echo $red = $fontDialog.Color.R >> !fontpickerpath!
echo $green = $fontDialog.Color.G >> !fontpickerpath!
echo $blue = $fontDialog.Color.B >> !fontpickerpath!
echo $hexshit = "#{0:X2}{1:X2}{2:X2}" -f $red, $green, $blue >> !fontpickerpath!
echo Write-Host "FontColor=$hexshit" >> !fontpickerpath!
echo } else { Write-Host "Canceled" } >> !fontpickerpath!

goto :EOF

:createnumberbox
rem set "numberboxpath=asd.ps1"
echo Add-Type -AssemblyName System.Windows.Forms> !numberboxpath!
echo Add-Type -AssemblyName System.Drawing>> !numberboxpath!
echo. >> !numberboxpath!

echo $form ^= New-Object System.Windows.Forms.Form>> !numberboxpath!
echo $form.Text ^= 'NSOVVG'>> !numberboxpath!
echo $form.Size ^= New-Object System.Drawing.Size^(250, 150^)>> !numberboxpath!
echo $form.StartPosition ^= 'CenterScreen'>> !numberboxpath!
echo. >> !numberboxpath!

echo $label ^= New-Object System.Windows.Forms.Label>> !numberboxpath!
echo $label.Text ^= "%~3">> !numberboxpath!
echo $label.AutoSize ^= $true>> !numberboxpath!
echo $label.Location ^= New-Object System.Drawing.Point(0, 10)>> !numberboxpath!
echo $form.Controls.Add($label)>> !numberboxpath!

echo $numericUpDown ^= New-Object System.Windows.Forms.NumericUpDown>> !numberboxpath!
echo $numericUpDown.Location ^= New-Object System.Drawing.Point^(50, 30^)>> !numberboxpath!
echo $numericUpDown.Width ^= 100 >> !numberboxpath!
echo $numericUpDown.Minimum ^= 0 >> !numberboxpath!
echo $numericUpDown.Maximum ^= %~1 >> !numberboxpath!
echo $numericUpDown.DecimalPlaces ^= 0 >> !numberboxpath!
echo $numericUpDown.Value ^= %~2 >> !numberboxpath!
ECHO $numericUpDown.Increment = %~4 >> !numberboxpath!
echo $form.Controls.Add^($numericUpDown^)>> !numberboxpath!
echo. >> !numberboxpath!

echo $okButton ^= New-Object System.Windows.Forms.Button>> !numberboxpath!
echo $okButton.Text ^= 'OK'>> !numberboxpath!
echo $okButton.Location ^= New-Object System.Drawing.Point^(30, 70^)>> !numberboxpath!
echo $okButton.Add_Click^({>> !numberboxpath!
echo     $form.Tag ^= $numericUpDown.Value>> !numberboxpath!
echo     $form.Close^(^)>> !numberboxpath!
echo }^)>> !numberboxpath!
echo $form.Controls.Add^($okButton^)>> !numberboxpath!
echo. >> !numberboxpath!

echo $cancelButton ^= New-Object System.Windows.Forms.Button>> !numberboxpath!
echo $cancelButton.Text ^= 'Cancel'>> !numberboxpath!
echo $cancelButton.Location ^= New-Object System.Drawing.Point^(120, 70^)>> !numberboxpath!
echo $cancelButton.Add_Click^({>> !numberboxpath!
echo     $form.Tag ^= 'None'>> !numberboxpath!
echo     $form.Close^(^)>> !numberboxpath!
echo }^)>> !numberboxpath!
echo $form.Controls.Add^($cancelButton^)>> !numberboxpath!
echo. >> !numberboxpath!

echo $form.Add_FormClosing^({>> !numberboxpath!
echo     if ^($form.Tag -eq $null^) {>> !numberboxpath!
echo         $form.Tag ^= 'None'>> !numberboxpath!
echo     }>> !numberboxpath!
echo }^)>> !numberboxpath!
echo. >> !numberboxpath!

echo $form.ShowDialog^(^) ^| Out-Null>> !numberboxpath!
echo. >> !numberboxpath!

echo Write-Host $form.Tag>> !numberboxpath!
echo. >> !numberboxpath!
echo. >> !numberboxpath!
for /f "usebackq delims=" %%i in (`powershell -NoProfile -ExecutionPolicy Bypass -File "!numberboxpath!"`) do (
			set selectedNumber=%%i
)
del /q !numberboxpath!
goto :eof

:render
:: 마스터 오디오 파일 (%1)
rem set "masterAudio=%~1"
rem echo on

:: 채널 오디오 파일들을 처리 (%2부터 끝까지)
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
set "bgcf1="
set "bgcf2="
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
rem set "beforeshowwaves=volume=!gain![g"
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
set "beforeshowwaves=volume=!amp%channelCount%![g"
if !channelCount! gtr !chcount! goto endloop
rem set /a channelCount+=1
set "channelInputs=!channelInputs! -i "!channel%channelCount%!""

if defined label!channelCount! (
	set "drawtext=[wave%channelCount%]drawtext=text='!label%channelCount%!':font='!dffont!':x=10:y=10:fontsize=!sizefont!:fontcolor=!colorfont![wave%channelCount%];"
) else (
	set "drawtext="
)

if !chcount! GTR !autosortvaule! (

	if !channelCount! LEQ !h2number! (
		set /a H1Count+=1
		if "!H1Count!"=="!h2number!" (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_reshalf!x!last_H1_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];!drawtext!"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H1Count![left];"
		) else (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_reshalf!x!H1_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];!drawtext!"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	) else (
		set /a H2Count+=1
		if "!H2Count!"=="!h1number!" (
				

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_reshalf!x!last_H2_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];!drawtext!"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H2Count![right];"
		) else (

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_reshalf!x!H2_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];!drawtext!"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	)
	
) else (
	if "!channelCount!"=="!chcount!" (
		if !chcount!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![g%channelCount%];[g%channelCount%]!drawtext!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];!drawtext!"
		)
	) else (
		if !chcount!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![g%channelCount%];[g%channelCount%]!drawtext!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[g%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!color%channelCount%!:rate=!fps!:scale=!scalemode![wave%channelCount%];!drawtext!"
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
set channelCount+=1
rem echo %channelCount% %i%
:: 최종 출력 레이아웃을 정의
if "!bgimage!"=="None" (
	set "bgcf1="
	set "bgcf2="
) else if "!bgimage:~0,1!"=="#" (
	set "bgcf1=color=c=!bgimage!:size=!x_res!x!y_res!:d=1 [bgimg];[bgimg][v2]overlay=x=0:y=0[v2]"
) else (
	set "bgcf1=[!channelCount!:v]scale='if(gt(iw/ih,!x_res!/!y_res!),!x_res!,-2)':'if(gt(iw/ih,!x_res!/!y_res!),-2,!y_res!)', pad=width=!x_res!:height=!y_res!:x=(ow-iw)/2:y=(oh-ih)/2[bgimg];[bgimg][v2]overlay=x=0:y=0[v2];"
	rem set "bgcf1=[!channelCount!:v]scale^=!x_res!:!y_res!:force_original_aspect_ratio^=decrease,pad^=!x_res!:!y_res!:-1:-1:color^=black[v2]"
	set "bgcf2=-i "!bgimage!" "
)

if "!chcount!"=="1" (
	set "layout=!layout!"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
) else if !chcount! GTR !autosortvaule! (
	set "filterComplex=!H1F!!H2F!"
	set "layout=!layout![left][right]hstack=inputs=2[v2];!bgcf1!"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
) else (
	set "layout=!layout!vstack=inputs=!chcount![v2];!bgcf1!"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
)
REM echo ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% -f nut
:playorrender
rem CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
if /i "!renderorpreview!"=="2" (
	del /q !progresslogpath!
	start conhost !progressbartestpath! "!masterAudio!" "!progresslogpath!"
	REM echo conhost !progressbartestpath! "!masterAudio!" "!progresslogpath!"
	echo ffmpeg -progress !progresslogpath! -loglevel quiet -stats -i "!masterAudio!" %channelInputs% !bgcf2!-filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% "!ffmpegoutput!"
	ffmpeg -progress !progresslogpath! -loglevel error -stats -i "!masterAudio!" %channelInputs% !bgcf2!-filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% "!ffmpegoutput!"
	rem pause
	rem fuckkkkkkkkk
	REM PAUSE
	echo None> !progresslogpath!
) else if /i "!renderorpreview!"=="1" (

	ffmpeg -loglevel quiet -stats -i "!masterAudio!" %channelInputs% !bgcf2!-filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% -f nut - | ffplay - 
	echo ^(Ignore if it said "Conversion failed^!"^)
	REM pause
	
) else (
	echo Aborted.
	exit
)
rem endlocal
goto drawlogo
