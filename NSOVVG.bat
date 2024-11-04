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
set "channelInputs="
set "filterComplex="
set "layout="
set argC=-1
for %%x in (%*) do Set /A argC+=1

set x_res=720
set y_res=480
set "colorvaule=White"
set "linemode=p2p"

set "stack_num=!argC!"

set /a stack_x_res=x_res / stack_num
set /a remainder=x_res %% stack_num
set /a last_stack_x_res=stack_x_res + remainder

rem echo !last_stack_x_res!

rem SET /A argc-=1
:loop
shift
if "%~1"=="" goto endloop
set /a channelCount+=1
set "channelInputs=!channelInputs! -i "%~1""
if "!channelCount!"=="!argC!" (
	if !argC!==1 (
		set "filterComplex=!filterComplex! [%channelCount%:a]showwaves=s=!last_stack_x_res!x!y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=log;"
	) else (
		set "filterComplex=!filterComplex! [%channelCount%:a]showwaves=s=!last_stack_x_res!x!y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=log[wave%channelCount%];"
	)
) else (
	if !argC!==1 (
		set "filterComplex=!filterComplex! [%channelCount%:a]showwaves=s=!stack_x_res!x!y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=log;"
	) else (
		set "filterComplex=!filterComplex! [%channelCount%:a]showwaves=s=!stack_x_res!x!y_res!:mode=!linemode!:colors=!colorvaule!:rate=60:scale=log[wave%channelCount%];"
	)
)
if !argC!==1 (
    set "layout="
) else (
    set "layout=!layout![wave%channelCount%]"
)
rem shift
goto loop

:endloop
echo %channelCount% %argC%
:: 최종 출력 레이아웃을 정의
if "!argC!"=="1" (
	set "layout=!layout!"
	set "outer=-c:v h264_qsv -format yuv420p"
) else (
	set "layout=!layout!hstack=inputs=%channelCount%[v2];"
	set "outer=-c:v h264_qsv -format yuv420p -map [v2]"
)
rem set "outer=-c:v h264_qsv -format yuv420p -map [v2]"

:: 최종 명령어 실행
 .\ffmpeg -y -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% output.mp4
echo ffmpeg -i "%masterAudio%" %channelInputs% -filter_complex "%filterComplex% %layout%" -map 0:a -c:a aac %outer% output.mp4
endlocal		
rem ffmpeg -y -i ".\master\temp_fur2oscmst.wav"  -i ".\master\temp_fur2oscmst.wav" -i "ch2.wav" -i "ch3.wav" -filter_complex " [1:a]showwaves=s=1280x720:mode=p2p:colors=Spectrum[wave1]; [2:a]showwaves=s=1280x720:mode=p2p:colors=Spectrum[wave2]; [3:a]showwaves=s=1280x720:mode=p2p:colors=Spectrum[wave3]; [wave1][wave2][wave3]hstack=inputs=3[v2];" -c:v h264_qsv -format yuv420p -map [v2] output.mp4