import os
import platform
if platform.system() == "Windows":
    import win32console

if platform.system() == "Linux":
    if not os.path.exists("/tmp/NSOVVG"):
        os.makedirs("/tmp/NSOVVG")
    tmp_path = "/tmp/NSOVVG/"
elif platform.system() == "Windows":
    if not os.path.exists("C:\\Windows\\Temp\\NSOVVG"):
        os.makedirs("C:\\Windows\\Temp\\NSOVVG")
    tmp_path = "C:\\Windows\\Temp\\NSOVVG\\"

global masteraudio = None
global bgimage = None
global x_res = 1280
global y_res = 720
global fps = 60
global bitrate = "5000k"
global linemode = "p2p"
global chosenfiles = []
global progressbartestpath = f"{tmp_path}displayrendering.bat"
global progresslogpath = f"{tmp_path}ffmpegprogresslog.log"
global fontpickerpath = f"{tmp_path}fontPicker.py"
global numberboxpath = f"{tmp_path}numberBox.py"
global reorderboxpath = f"{tmp_path}reorder.py"
global dffont = "Arial"
global displayfont = "Arial"
global fontsize = 14
global fontcolor = "#FFFFFF"
if os.path.exists(progresslogpath):
    os.remove(progresslogpath)
    os.remove(progressbartestpath)
    os.remove(reorderboxpath)

def set_title(msg):
    if platform.system() in ["Linux", "Darwin"]: # linux or macos. if macos does not function correctly when preforming this, please make an issue.
        GOOD_TERMINALS = ["xterm"]
        if os.getenv("TERM") in GOOD_TERMINALS:
            print("\x1B]0;%s\x07" % msg)
    elif platform.system() == "Windows":
        win32console.SetConsoleTitle(msg)        

set_title("Not Serious Oscilloscope View Video Generator - original by @희민Heemin, Python port by Swirly")
# chcp 949?? what??
resetvariables()
