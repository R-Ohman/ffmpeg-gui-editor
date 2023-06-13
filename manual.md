.TH EDITOR 1 "11 June 2023" "1.0" "Editor Manual"

.SH NAME
\fBEditor\fR - Bash script for editing audio and video files

.SH SYNOPSIS
.B Editor
[\fIOPTION\fR] [\fIoptional argument\fR]

.SH DESCRIPTION
\fIEditor\fR is a Bash script that allows you to perform various operations on audio and video files. It provides an interactive menu where you can choose to edit volume, change file format, set video size, edit duration, and adjust speed. The script utilizes FFmpeg for file manipulation.

.SH OPTIONS
The following options are available for \fIEditor\fR:

.TP
\fB-f \fIFILE\fR
Specifies the input file to be processed. If not provided, a file selection dialog will be displayed.

.SH OVERVIEW
The \fIEditor\fR script provides a user-friendly way to edit audio and video files by offering various options through a graphical user interface (GUI) created using Zenity. It utilizes FFmpeg, a powerful multimedia framework, for performing the actual file manipulations.

.SH EXAMPLES
To edit the volume of an audio or video file, run the script and choose the "Edit Volume" option from the menu. You will be prompted to enter the desired volume level.

To change the file format of an audio or video file, run the script and choose the "Change File Format" option from the menu. The script will automatically detect the input file format and present a list of available output formats to choose from.

.SH FILES
.TP
\fIEditor\fR 
- The Bash script file.

.SH AUTHOR
Written by Ruslan Rabadanov (\fIs196634@student.pg.edu.pl\fR)

.SH REPORTING BUGS
Please report any bugs or issues at: \fIhttps://github.com/R-Ohman/bash_editor/issues\fR

.SH COPYRIGHTS
This script is released under the MIT License. See the LICENSE file for more details.

.SH SEE ALSO
FFmpeg documentation: \fIhttps://ffmpeg.org/documentation.html\fR

.SH HISTORY
.TP

30.05.2023: Initial version created by Ruslan Rabadanov.
06.06.2023: Last modification made by Ruslan Rabadanov.
