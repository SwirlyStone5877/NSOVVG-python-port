@echo off
setlocal enabledelayedexpansion
title NSOVVG - Not Serious Oscilloscope View Video Generator
echo [101;93mFor some reason, file names containing hyphens (-) occurs an error when validating arguments.[0m
echo [1;95mSince this does not yet have the ability to save and load presets, all settings can only be changed on line 40 of this script.[0m

:: 입력 인수 확인
if "%1"=="" (
    echo Please provide the master audio channel^^!
    exit /b
)
if "%2"=="" (
    echo Please provide at least one channel^^!
    exit /b
)

:: 마스터 오디오 파일 (%1)
set "masterAudio=%~1"

:: 채널 오디오 파일들을 처리 (%2부터 끝까지)
set channelCount=0
set H1Count=0
set H2Count=0
set "channelInputs="
set "filterComplex="
set "layout="
set "autosortvaule=4"
set argC=-1
for %%x in (%*) do (
	if exist "%%x" (

		Set /A argC+=1
		
	) else (
		echo Error^^! The file "%%x" does not exist^^!
		exit
	)
)
::USER CONFIG VAULES::
set x_res=1280
set y_res=720
set "colorvaule=White"
set "linemode=p2p"
set "bitrate=5000k"
set "scalemode=lin"
set "gain=4"
set "gpu=h264_qsv"
set "fps=60"
::USER CONFIG VAULES_END::

set "beforeshowwaves=volume=!gain![gained"
set "stack_num=!argC!"
set /a stack_y_res=y_res / stack_num
set /a remainder=y_res %% stack_num
set /a last_stack_y_res=stack_y_res + remainder

if !argC! GTR !autosortvaule! (
	echo AUTO CHANNEL SORTING

	set /a h1number=!argC! / 2
	set /a hremainder=!argC! %% 2

	if !hremainder! equ 0 (
		set /a h1number=!argC! / 2
		set /a h2number=!argC! / 2
	) else (
		set /a h1number=!argC! / 2
		set /a h2number=!hremainder! + !h1number!
	)
	echo !h2number! !h1number!
	set /a H1_y_res=y_res / h2number
	set /a H1remainder=y_res %% h2number
	set /a last_H1_y_res=H1_y_res + H1remainder

	set /a H2_y_res=y_res / h1number
	set /a H2remainder=y_res %% h1number
	set /a last_H2_y_res=H2_y_res + H2remainder

	set /a x_res=x_res/2
	echo !x_res!
	ECHO H1 : !H1_y_res!, !last_H1_y_res!
	echo H2 : !H2_y_res!, !last_H2_y_res!

)
:loop
shift
if "%~1"=="" goto endloop
set /a channelCount+=1
set "channelInputs=!channelInputs! -i "%~1""
if !argC! GTR !autosortvaule! (

	if !channelCount! LEQ !h2number! (
		set /a H1Count+=1
		if "!H1Count!"=="!h2number!" (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_H1_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H1Count![left];"
		) else (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!H1_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	) else (
		set /a H2Count+=1
		if "!H2Count!"=="!h1number!" (
				

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_H2_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H2Count![right];"
		) else (

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!H2_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	)
	
) else (
	if "!channelCount!"=="!argC!" (
		if !argC!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode![wave%channelCount%];"
		)
	) else (
		if !argC!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=!fps!:scale=!scalemode![wave%channelCount%];"
		)
	)
	if !argC!==1 (
		set "layout="
	) else (
		set "layout=!layout![wave%channelCount%]"
	)
)
rem shift
goto loop

:endloop

echo %channelCount% %argC%
:: 최종 출력 레이아웃을 정의
if "!argC!"=="1" (
	set "layout=!layout!"
	set "outer=-c:v !gpu! -format yuv420p"
) else if !argC! GTR !autosortvaule! (
	set "filterComplex=!H1F!!H2F!"
	set "layout=!layout![left][right]hstack=inputs=2[v2];"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
) else (
	set "layout=!layout!vstack=inputs=%channelCount%[v2];"
	set "outer=-c:v !gpu! -format yuv420p -map [v2]"
)

:playorrender
CHOICE /C PR /N /M "Press "P" to preview, or "R" to render. "
if /i "!ERRORLEVEL!"=="2" (

	ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% output.mp4
	
) else if /i "!ERRORLEVEL!"=="1" (

	ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% -f nut - | ffplay - 
	echo ^(Ignore if it said "Conversion failed^!"^)
	
) else (
	echo Aborted.
	exit
)
endlocal