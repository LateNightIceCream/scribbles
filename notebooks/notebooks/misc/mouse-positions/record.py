import csv
import subprocess
import time
import datetime


OUTPUT_FILE = "output.csv"


with open(OUTPUT_FILE, "w") as file:
    writer = csv.writer(file)
    writer.writerow(["time", "mouse_x", "mouse_y"])
    now = datetime.datetime.now()
    while True:
        mxy = subprocess.check_output(["hyprctl", "cursorpos"])
        t = time.time()
        xy = mxy.decode("utf-8").strip('\n').split(',')
        tstr = "{:.3f}".format(t)
        writer.writerow([tstr, xy[0], xy[1].strip(' ')])
        time.sleep(1)
