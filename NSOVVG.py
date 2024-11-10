import os
import platform
import GPUtil

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

masteraudio = None
bgimage = None
x_res = 1280
y_res = 720
fps = 60
bitrate = "5000k"
linemode = "p2p"
chosenfiles = []
progressbartestpath = f"{tmp_path}displayrendering.bat"
progresslogpath = f"{tmp_path}ffmpegprogresslog.log"
fontpickerpath = f"{tmp_path}fontPicker.py"
numberboxpath = f"{tmp_path}numberBox.py"
reorderboxpath = f"{tmp_path}reorder.py"
dffont = "Arial"
displayfont = "Arial"
fontsize = 14
fontcolor = "#FFFFFF"
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
print("Creating external scripts, please wait...")
def get_available_gpus():
    local_device_protos = device_lib.list_local_devices()
    return [x.name for x in local_device_protos if x.device_type == 'GPU']
print("Detecting GPU(s)...")
gpus = GPUtil.getGPUs()
for gpu in gpus:
    if "NVIDIA" in gpu.name.split(" "):
        gpu = "h264_nvenc"
        break
    elif "Intel" in gpu.name.split(" "):
        gpu = "h264_qsv"
        break
    elif "AMD" in gpu.name.split(" "):
        gpu = "h264_amf"
        break
try:
    gpu
except NameError:
    if gpus == []:
        print("No GPU(s) found, assuming libx264...")
    gpu = "libx264"

with open(progressbartestpath, "w") as f:
    pass
