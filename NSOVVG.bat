@echo off
setlocal enabledelayedexpansion

:: 입력 인수 확인
if "%1"=="" (
    echo 마스터 오디오 파일을 지정해야 합니다.
    exit /b
)
if "%2"=="" (
    echo 적어도 하나의 채널 오디오 파일을 지정해야 합니다.
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
for %%x in (%*) do Set /A argC+=1

::USER CONFIG VAULES::
set x_res=1280
set y_res=720
set "colorvaule=White"
set "linemode=p2p"
set "bitrate=1000k"
set "scalemode=lin"
set "gain=4"

set "beforeshowwaves=volume=!gain![gained"
set "stack_num=!argC!"
set /a stack_y_res=y_res / stack_num
set /a remainder=y_res %% stack_num
set /a last_stack_y_res=stack_y_res + remainder

echo !last_stack_y_res!, !stack_y_res!, !x_res!
rem exit
rem echo !last_stack_y_res!

rem SET /A argc-=1

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
	set /a last_H1_y_res=H1_y_res + remainder

	set /a H2_y_res=y_res / h1number
	set /a H2remainder=y_res %% h1number
	set /a last_H2_y_res=H2_y_res + remainder

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

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_H1_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H1Count![left];"
		) else (

				set "H1F=!H1F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!H1_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	) else (
		set /a H2Count+=1
		if "!H2Count!"=="!h1number!" (
				

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_H2_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]vstack=inputs=!H2Count![right];"
		) else (

				set "H2F=!H2F! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!H2_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode![wave%channelCount%];"
				set "layout=!layout![wave%channelCount%]"
		)

			REM :: set "layout=!layout![wave%channelCount%]"

	)
	
REM exit
) else (
	if "!channelCount!"=="!argC!" (
		if !argC!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!last_stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode![wave%channelCount%];"
		)
	) else (
		if !argC!==1 (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode!;"
		) else (
			set "filterComplex=!filterComplex! [%channelCount%:a]!beforeshowwaves!%channelCount%];[gained%channelCount%]showwaves=s=!x_res!x!stack_y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=!scalemode![wave%channelCount%];"
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
	set "outer=-c:v h264_qsv -format yuv420p"
) else if !argC! GTR !autosortvaule! (
	set "filterComplex=!H1F!!H2F!"
	set "layout=!layout![left][right]hstack=inputs=2[v2];"
	set "outer=-c:v h264_qsv -format yuv420p -map [v2]"
) else (
	set "layout=!layout!vstack=inputs=%channelCount%[v2];"
	set "outer=-c:v h264_qsv -format yuv420p -map [v2]"
)
echo !layout!


rem set "outer=-c:v h264_qsv -format yuv420p -map [v2]"

:: 최종 명령어 실행
 rem .\ffmpeg -y -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac -b:v !bitrate! -b:a 240k %outer% output.mp4
rem  echo  .\ffmpeg -y -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac -b:v !bitrate! -b:a 240k %outer% output.mp4
ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% output.mp4
endlocal		
rem ffmpeg -y -i ".\master\temp_fur2oscmst.wav"  -i ".\master\temp_fur2oscmst.wav" -i "ch2.wav" -i "ch3.wav" -filter_complex " [1:a]showwaves=s=1280x720:mode=p2p:colors=Spectrum[wave1]; [2:a]showwaves=s=1280x720:mode=p2p:colors=Spectrum[wave2]; [3:a]showwaves=s=1280x720:mode=p2p:colors=Spectrum[wave3]; [wave1][wave2][wave3]vstack=inputs=3[v2];" -c:v h264_qsv -format yuv420p -map [v2] output.mp4