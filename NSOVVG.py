import os
import platform
if platform.system() == "Windows":
    import win32console
    

def set_title(msg):
    if platform.system() in ["Linux", "Darwin"]: # linux or macos. if macos does not function correctly when preforming this, please make an issue.
        GOOD_TERMINALS = ["xterm"]
        if os.getenv("TERM") in GOOD_TERMINALS:
            print("\x1B]0;%s\x07" % msg)
    elif platform.system() == "Windows":
        win32console.SetConsoleTitle(msg)        
