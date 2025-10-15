Key features include:

Custom Application & Script Launcher:

Remaps multimedia keys to instantly open applications like Notepad (Launch_Mail), the Calculator (Launch_App2), and the Command Prompt (Launch_App1).

Repurposes the Browser_Home key to execute a custom batch script (QuickSleep.bat) that manages display settings before putting the computer to sleep.

Advanced Audio Device Switching:

Transforms the Volume_Mute and Launch_Media keys into a toggle for quickly switching the default audio output between speakers and headphones.

Utilizes PowerShell AudioDevice cmdlets to dynamically identify and set the audio device.

Intelligently prioritizes which device to select based on predefined keywords like "SONY" or "Realtek".

Smart Sleep Routine (QuickSleep.bat):

A script that first switches the video output to a target screen, like an external monitor , and then puts the system to sleep.

On its first run, it automatically creates a desktop shortcut to itself with a pre-configured system icon for easy access.
QuickSleep - Use Case Scenario

When you're using a secondary monitor (which is usually off and only turned on for gaming or watching movies), and you want to quickly put your computer to sleep, but you also want the login screen to appear on your primary monitor (your computer's main display) when you wake it up, you need to switch back to your primary monitor before sleeping. Otherwise, the next time you turn on your computer, you might not be able to log in (because the login screen could appear on the secondary monitor).

QuickSleep - How to Use

Download this .bat file, edit and set the target display, icon, and so on, then run it. This script will create a shortcut on your desktop. Each time you run this shortcut, it will switch to the specified display and then put your computer to sleep.
