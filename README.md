# Eurotruck Simulator 2 Load Remover

This repository conains a script for livesplit that allows you to automaticly remove the load times from you splits. It makes use of a the Software development kit (SDK) made available by SCS. This SDK sends Telemetry data from the game so that 3rd party applications to use.

## Installation
The installation process is Split in three parts Downloading this repository, downloading the SDK handler and configuring livesplit.

### Downloading this repository
In order to download this repository click on the code button then you can select "download ZIP" this downloads this repository to your pc. Move the zip to a folder where you can find it again later. After moving Unzip the repository by right clicking and selecting "unpack in ETS2-Autosplitter-main/".

### Installing the SDK handler

In order to read the games values this script makes use of another program. To install this program you go to this link: https://github.com/RenCloud/scs-sdk-plugin. On the right side of the page you will find the releases each release corresponds to a different version of ETS2. In the table below you can lookup the correct release version you would need to download for your game version. A note: if you use version 1.26 or lower to run you game you need to build the package yourself. This creates a folder named ETS2-Autosplitter-main which contains the load remover.

Game version | Release version| Tested
-------------|----------------|----------
< 1.26          |1_5                 |Not tested
1.27-1.31       |v1.9.0              |Not tested
1.32            |V.1.10.6            |Tested
1.33            |V.1.10.6            |Not tested
1.34            |V.1.10.6            |Npt tested
1.35            |v.1.10.6            |Not tested
1.36            |v.1.10.6            |Not tested
1.37            |v.1.10.6            |Not tested
1.38            |v.1.10.6            |Not tested
1.39            |v.1.10.6            |Not tested
1.40            |v.1.10.6            |Tested

After downloading the correct release for you game. Go to the Eurotruck game folder, this folder can be found in in the folder "C:\Program Files (x86)\Steam\steamapps\common\Euro Truck Simulator 2" if you install games in a custom folder you can find it there. When in there open the bin folder. You will see 2 folders win_x64 and win_x86. Open win_x86 there you will find the executable for ETS2 in here we create a folder named plugins if the folder already exist use that one. Now open the zip we just downloads and go into the Win64 folder and drag the file "scs-telemetry.dll" to the plugin folder we just created.

### Configuring livesplit

The last thing we need to do is to do is configure timesplit to use the load remover script. To do this open livesplit, right click and select "edit layout". A screen should appear click the + button in the left of the screen and select under control "Scriptable Auto Splitter". This adds a row by the same name. Dubbel click on that row. Another screen should appear with input bar named "Script path" click browse and select the file "ETS2-Autosplitter.asl" saved in the first step. 

Live split has two different timers one timer is a "real time" timer and the other is the "game time" timer. When a load remover only the timer that measures game time is affected. So we need to change the timing method to game time, this can be done in two ways the fist is to dubbel click on the timer row in Layout settings and change the timing method from "current timing method" to "game time". The other way is to change the current timing method to do this exit the edit layout screen and right click on the timer and select "game time" under "compare against".

### Testing the load remover and sdk handler

Now that these steps are done open ETS2. When entering the profile menu a popup should appear saying an SDK is found and loaded. This means that the SDK handler is working, if this screen does not appear go back to the section installing sdk but instead of putting the win_x86 try the same steps but in win_x64. 

During the loading of your profile you can test if the load remover is working by starting the timer if the timer stops than the load remover is working. If the load remover is still not working try each step again to see if every thing is pressent.
