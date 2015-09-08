# RickyTV
Media player for people who have mental disabilities

# Goals:
- Cheap processing power - Raspberry Pi
- Ease of use hardware - arcade-style buttons on hardened console
- Ease of use software - custom software to allow for poweron/play functionality. 
- Resiliant cabinent - Tamper and damage resistant
- Easy image flashing instructions for linux/mac/windows
- Touchless OS - no internet connection, never drop to where user needs to interact with system itself, only interface.

# Software:
- Base - Debian or Gentoo
- Player - omxplayer - utilizes raspberry pi's hardware decoding for playback
- Interface - Perl script that auto-starts with the system, reads from a video directory and runs from the framebuffer
- Input - controls via button to usb-keyboard translation - still in progress
- Videos - Pre-transcoded for PI via handbrake (will include instructions)
