# Overview
The `Editor.sh` script is a Bash tool designed for editing audio and video files. It provides an interactive menu using Zenity and utilizes the FFmpeg framework for file manipulation. The script allows users to perform various operations, including editing volume, changing file format, setting video size, editing duration, adjusting speed, and saving the edited file.

## Features
### Edit Volume

- Adjust the volume level of the audio or video file.
### Change File Format

- Convert the file format between supported formats for audio (WAV, MP3) and video (AVI, MOV, MP4).
### Set Video Size

- Resize the video by specifying the new width and height in pixels.
### Edit Duration

- Trim the video by specifying the start time and duration.
### Set Speed

- Change the speed of the video while maintaining audio synchronization.
### Save

- Save the edited file to a specified location.
## Usage
The script can be run from the command line with optional arguments or without, triggering a file selection dialog. The available options include:

-f FILE: Specifies the input file to be processed.
## Examples
To edit the volume of a file, choose the "Edit Volume" option from the menu and enter the desired volume level.

To change the file format, select the "Change File Format" option, and the script will guide you through the available output formats.

## Additional Resources
[FFmpeg Documentation](https://ffmpeg.org/documentation.html)
