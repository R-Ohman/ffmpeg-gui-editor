#!/bin/bash
# Author : Ruslan Rabadanov 2023 (s196634@student.pg.edu.pl)
# Created on: 30.05.2023
# Last modified by : Ruslan Rabadanov 2023 (s196634@student.pg.edu.pl)
# Last modified on: 06.06.2023

# Function to create a temporary copy of the input file
create_temp_file() {
   local input_file="$1"
    local filename=$(basename "$input_file")
    local extension="${filename##*.}"
    if [ -z "$extension" ]; then
        echo "Invalid input file format."
        exit 1
    fi
    
   local temp_file="/tmp/${filename%.*}.$$.$extension"
    
    ffmpeg -i "$input_file" -c copy "$temp_file"
    
    echo "$temp_file"
}


# Function to change the volume ( 0-200% )
edit_volume() {
    local temp_file="$1"
    local volume_level=$(zenity --scale --title="Edit Volume" --text="Enter the volume level:" --min-value=0 --max-value=200 --value=100 --step=1)
    
    ffmpeg -i "$temp_file" -filter:a "volume=$volume_level/100" -c:v copy "${temp_file%.*}_edited.${temp_file##*.}"
    mv "${temp_file%.*}_edited.${temp_file##*.}" "$temp_file"
    
    zenity --info --title="Volume Edited" --text="The volume of the file has been edited."
}


# Function to change file format (MP3, WAV for audio, MP4, AVI, MOV for video)
change_file_format() {
    local temp_file="$1"
    local input_ext=$(echo "$temp_file" | awk -F . '{print tolower($NF)}')

    local output_format=""
    echo $input_ext
    if [ "$input_ext" = "mp3" ] || [ "$input_ext" = "wav" ]; then
                output_format=$(zenity --list --title="Select Output Format" --column="Format" "WAV" "MP3")
            elif [ "$input_ext" = "mp4" ] || [ "$input_ext" = "avi" ] || [ "$input_ext" = "mov" ]; then
                output_format=$(zenity --list --title="Select Output Format" --column="Format" "AVI" "MOV" "MP4")
            else
        echo "Invalid input file format."
        return 1
    fi

    if [ -z "$output_format" ]; then
        echo "Output format not selected."
        return 1
    fi

    local output_file="${temp_file%.*}_edited.${temp_file##*.}"

    ffmpeg -i "$temp_file" -codec:a copy -codec:v copy "$output_file"
	mv "${temp_file%.*}_edited.${temp_file##*.}" "$temp_file"

    zenity --info --title="File Format Changed" --text="The file format has been changed."
}



# Function to set video size (width and height in pixels)
set_video_size() {
    local temp_file="$1"
    local new_size=""
    local valid_size=false
    
    while [ "$valid_size" = false ]; do
        new_size=$(zenity --entry --title="Set Video Size" --text="Enter the new video size (format: WIDTHxHEIGHT):")
        
        # Check if the entered size has the correct format (WIDTHxHEIGHT)
        if [ "$(echo "$new_size" | grep -E '^[0-9]+[xX][0-9]+$')" ]; then
            valid_size=true
        else
            zenity --error --title="Invalid Size Format" --text="The entered size format is invalid. Please use the format WIDTHxHEIGHT."
        fi
    done
    
    ffmpeg -i "$temp_file" -vf "scale=$new_size" -c:a copy "${temp_file%.*}_edited.${temp_file##*.}"
    mv "${temp_file%.*}_edited.${temp_file##*.}" "$temp_file"
    
    zenity --info --title="Video Size Set" --text="The video size has been set."
}



# Function to edit file duration
edit_duration() {
    local temp_file="$1"
    local original_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$temp_file")
    
    if [ -z "$original_duration" ]; then
        echo "Unable to retrieve file duration."
        exit 1
    fi
    
    local start_time=$(zenity --entry --title="Edit File Duration" --text="Enter the start time of the trimmed video (in seconds):")
    if (( $(awk 'BEGIN{print ('$start_time' > '$original_duration')}') )); then
        zenity --error --title="Invalid Start Time" --text="The specified start time is greater than the duration of the file ($original_duration seconds)."
        return
    fi
    
    local duration=$(zenity --entry --title="Edit File Duration" --text="Enter the duration of the trimmed video (in seconds):")
    if (( $(awk 'BEGIN{print ('$duration' > '$original_duration' - '$start_time')}') )); then
        zenity --error --title="Invalid Duration" --text="The specified duration is greater than the available duration in the file after trimming ($original_duration - $start_time seconds)."
        return
    fi
    
    ffmpeg -ss "$start_time" -i "$temp_file" -t "$duration" -c copy "${temp_file%.*}_edited.${temp_file##*.}"
    mv "${temp_file%.*}_edited.${temp_file##*.}" "$temp_file"
    
    zenity --info --title="File Duration Edited" --text="The duration of the file has been edited."
}

# Function to set speed
set_speed() {
    local temp_file="$1"
    local speed=$(zenity --scale --title="Change speed" --text="Choose the speed (%):" --min-value=50 --max-value=500 --value=100 --step=1)
    local video_speed=$(awk "BEGIN { printf \"%.2f\", 100/$speed }")
    local audio_speed=$(awk "BEGIN { printf \"%.2f\", $speed/100 }")
    
    ffmpeg -i "$temp_file" -vf "setpts=$video_speed*PTS" -af "atempo=$audio_speed" "${temp_file%.*}_edited.${temp_file##*.}"
    mv "${temp_file%.*}_edited.${temp_file##*.}" "$temp_file"
    
    zenity --info --title="Speed Set" --text="The video speed has been set."
}

# Function to save edited file
save_file() {
    local temp_file="$1"
    local output_file=$(zenity --file-selection --save --title="Save Edited File" --filename="$PWD/edited_$(basename "$input_file")")
    
    cp "$temp_file" "$output_file"
    
    zenity --info --title="File Saved" --text="The edited file has been saved."
}

while getopts "f:" opt; do
    case $opt in
	f) input_file="$OPTARG"
	   ;;
	/?) echo "Unknown otion."
	;;
    esac
done


if [ -z "$input_file" ]; then
	input_file=$(zenity --file-selection --title="Select Input File" --filename="$PWD" --file-filter='*.mp3 *.MP3 *.mp4 *.MP4 *.avi *.AVI *.mov *.MOV *.wav *.WAV')
fi

if [ -z "$input_file" ]; then
    exit 0
fi

temp_file=$(create_temp_file "$input_file")

while true; do
    operation=$(zenity --list --title="Main Menu" --column="Operation" \
        "Edit Volume" \
        "Change File Format" \
        "Set Video Size" \
        "Edit Duration" \
        "Set Speed" \
        "Save" \
        "Quit without save")

    if [ $? -ne 0 ]; then
        break
    fi

    case "$operation" in
        "Edit Volume")
            edit_volume "$temp_file"
            ;;

        "Change File Format")
            change_file_format "$temp_file"
            ;;

        "Set Video Size")
            set_video_size "$temp_file"
            ;;

        "Edit Duration")
            edit_duration "$temp_file"
            ;;

        "Set Speed")
            set_speed "$temp_file"
            ;;

        "Save")
            save_file "$temp_file"
            break
            ;;

        "Quit without save")
            break
            ;;
    esac
done

rm "$temp_file"  # Remove the temporary file
