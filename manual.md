.\" Manpage for Editor
.TH EDITOR 1 "11 June 2023" "1.0" "Editor Manual"

.SH NAME
your_script \- Bash script for editing audio and video files

.SH SYNOPSIS
Editor [OPTION] [optional argument]

.SH DESCRIPTION
Editor is a Bash script that allows you to perform various operations on audio and video files. It provides an interactive menu where you can choose to edit volume, change file format, set video size, edit duration, and adjust speed. The script utilizes FFmpeg for file manipulation.

.SH OPTIONS
The following options are available for Editor:

.TP
.B \-f FILE
Specifies the input file to be processed. If not provided, a file selection dialog will be displayed.

.SH AUTHOR
Written by Ruslan Rabadanov (s196634@student.pg.edu.pl)

.SH REPORTING BUGS
Please report any bugs or issues at: https://github.com/R-Ohman/bash_editor/issues

.SH COPYRIGHTS
This script is released under the MIT License. See the LICENSE file for more details.

.SH SEE ALSO
FFmpeg documentation: https://ffmpeg.org/documentation.html

.SH OVERVIEW
The script provides a user-friendly way to edit audio and video files by offering various options through a graphical user interface (GUI) created using Zenity. It utilizes FFmpeg, a powerful multimedia framework, for performing the actual file manipulations.

.SH EXAMPLES
To edit the volume of an audio or video file, run the script and choose the "Edit Volume" option from the menu. You will be prompted to enter the desired volume level.

To change the file format of an audio or video file, run the script and choose the "Change File Format" option from the menu. The script will automatically detect the input file format and present a list of available output formats to choose from.

.SH EXIT STATUS
The script returns the following exit status codes:

0 - Successful execution.
1 - Invalid input or error occurred during file processing.

.SH FILES
- your_script: The Bash script file.
- LICENSE: The license file for your_script.

.SH HISTORY
- 30.05.2023: Initial version created by Ruslan Rabadanov.
- 06.06.2023: Last modification made by Ruslan Rabadanov.
