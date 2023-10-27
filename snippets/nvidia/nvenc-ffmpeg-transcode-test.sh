ffmpeg -y -vsync 0 -hwaccel cuda -hwaccel_output_format cuda -extra_hw_frames 8 -i "$1" -c:a copy -c:v h264_nvenc -b:v 5M "$2"

