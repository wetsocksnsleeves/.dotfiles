#!/usr/bin/env python3

# DaVinci Import media via Dolphin
# Author: Andrew Shark

import subprocess

# If run from external location (i.e. not from ~/.local/share/DaVinciResolve/Fusion/Scripts/Utility/), we need to import resolve object
# Note that in that case you also need to use environment variables as described in dr documentation.
try:
    resolve
except:
    import DaVinciResolveScript as dvr_script
    resolve = dvr_script.scriptapp("Resolve")

print("Started")

mediaPool = resolve.GetProjectManager().GetCurrentProject().GetMediaPool()

p = subprocess.run("zenity --file-selection --title='Import Media' --multiple --separator='\n' --filename=$HOME/Videos/", capture_output=True, shell=True)

print(p.stderr.decode())
files_to_import = p.stdout.decode().rstrip().split("\n")
print("Importing files:\n" + "\n".join(files_to_import))
mediaPool.ImportMedia(files_to_import)
print("Finished")
