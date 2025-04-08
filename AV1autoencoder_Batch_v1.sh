#!/bin/bash

# FUNCTION LIST
# header - Header
# Batch - Batch mode launcher
# check_batch_files - Pre-check before batch encoding
# Start_batch - Start batch encoding
# cancel - Exit the script
# Go_back - Go back to the mode selection menu
# Start_selection - First function of the script
# AOMENC-AV1_batch - Experimental batch process (AOMENC)
# SVT_AV1_PSY_batch - Experimental batch process (SVT_AV1)

# Static header of the program (does not contain the mode blinking)

header() {
clear
# Return pointer to position 0 0
tput cup 0 0
printf  "=======================================\n     AV1 autoencoder v1 by Varo486 \n=======================================\n  Overcomplicating things since 1997!"
# Shift change scroll region to line 4
tput csr 4 $((`tput lines` - 4))
# Move cursor to line 4
tput cup 4 0
}

Completed() {
#tput cup 5 8
echo "Process completed!"
echo ""
beep -f 932 -l 500 -D 700 -n -f 1244 -D 250 -n -f 932 -D 250 -n -f 1244 -n -f 1397 -n -f 1480
read -p " Do you want to perform another encode? [Y/n]" prompt
if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
then
# Rejected, close script
cancel
else
# Approved, do another encoding
Go_back
fi

}

check_batch_files() {
# List files that match the container variable
count=`ls -1 *$container 2>/dev/null | wc -l`
# If count is not 0, launch the batch start function.
if [ $count != 0 ]
then
Start_batch
else
echo -e "\033[91mError 2, no files with $container format found in this directory.\033[39m"
beep -f 640 -l 400 -r 3
Batch
fi
}

# Abort
cancel() { echo "Exiting the script, have a nice day!."
  sleep 1
  beep -f 3000 -l 60 -r 4 -d 50
  clear
  exit 0
  }

# Go back to mode selection
Go_back() {
echo "Going back..."
    sleep 1
    beep -f 3000 -l 60 -r 4 -d 50
    clear
    header
    echo ""
    echo -e "\033[93mThis script is under development and may have bugs.\033[39m"
    echo ""
    Start_selection
    }

# Batch encoding for an entire directory

Batch() { read -p "Enter the container format to scan: (mp4, mkv, avi, etc.): " container
  if [[ $container == "mp4" || $container == "mkv" || $container == "avi" ]]
  then
  read -p "You selected '$container', is this correct? [Y/n]" prompt
   if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
   then
   # No, restart function.
    Batch
    else
   # Yes, start checking.
    check_batch_files
    fi
   # Incorrect format specified.
    else
    echo -e "\033[91mError 1, incompatible format specified.\033[39m"
    beep -f 640 -l 400
    Batch
    fi
    }

# Start of batch process, mode selection
Start_batch() { read -p "Do you want to encode video files with AOMENC-AV1 (VERY SLOW)? [y/N]" prompt
     if [[ $prompt == "y" || $prompt == "Y" || $prompt == "Yes" || $prompt == "yes" ]]
     then
     AOMENC_AV1_batch
     else
     read -p "Do you want to encode video files with SVT-AV1-PSY (FASTER THAN AOMENC)? [Y/n]" prompt
     if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
     then
       read -p "Do you want to use ab-av1 to calculate an approximate CRF with VMAF in that case? [Y/n]" prompt
       if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
        then
        Go_back
        else
      # ab-av1 - CRF Search
        clear
        header
      # Show selected mode on line 4, column 6
        tput cup 4 7
        printf "\033[1;34m\e[5mMode: ab-av1 - CRF Search\033[0m"
        tput csr 5 $((`tput lines` - 5))
        tput cup 6 0
      # LOOP TO SELECT A NUMBER FROM 0 TO 13
        while true; do
                      read -p "Choose the AV1 preset to calculate the CRF [0-13] (Recommended: 4) " preset
      # CHECK THAT THE NUMBER IS WITHIN LIMITS
                      if [[ $preset =~ ^[0-9]+$ ]] && [ "$preset" -ge 0 ] && [ "$preset" -le 13 ]; then
                      echo "Chosen preset: $preset"
                      break
                      else
                      echo -e "\033[0;33mInvalid preset. Enter a number from 0 to 13.\033[0m"
                      beep -f 640 -l 400
                      fi
                    done
     sleep 2
    # START CRF TESTING
     for file in *.$container
      do
       echo -e "Calculating CRF for the file \033[0;32m"$file"\033[0m with preset \033[0;32m$preset\033[0m..."
       ab-av1 crf-search -i "$file" --preset $preset
       beep -f 800 -l 200 -n -f 640
      done
      #header
      echo ""
      Completed
       fi
     # AOMENC
       else
       SVT_AV1_PSY_batch
       fi
       fi
       }

# Mode selection menu

Start_selection () { PS3="Start or exit: "
select mode in "Start" "Exit"
do
case $mode in
Start)
beep -f 3000 -l 60 -r 4 -d 50
echo -e "\033[0;31mIMPORTANT! To use this mode, you must have placed the script in the directory with the files!\033[0m"
echo -e "The working directory is '\033[0;33m$PWD\033[0m'."
echo -e "\033[0;31mThis script is VERY slow and could take hours, days, or weeks depending on what you choose!\033[0m"
read -p "Are you sure you want to continue? [Y/n]" prompt
if [[ $prompt == "n" || $prompt == "N" || $prompt == "No" || $prompt == "no" ]]
then
# Rejected, go back to the selection menu
Go_back
else
Batch
fi
;;
Exit)
cancel
;;
esac
done
}

AOMENC_AV1_batch() {
clear
header
# Show selected mode on line 4, column 6
  tput cup 4 7
  printf "\033[1;34m\e[5mMode: AOMENC - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # Shift change scroll region to line 6
  tput csr 6 $((`tput lines` - 6))
  # Place cursor in line 6, column 0
  tput cup 6 0
  echo "    === AOMENC-AV1 Batch Encoder ==="
  echo -e "WRITE PARAMETERS MANUALLY, OTHERWISE THEY WILL NOT BE VALID"
  read -p "Desired CRF (0-63) (Recommended 19-21): " CRF
  read -p "Denoising level (0-3) (Recommended: 0): " DENOISE_LEVEL
  read -p "Artificial grain level (0-50) (Recommended: 10): " FILM_GRAIN
  read -p "Preset cpu_used (0-8 - lower is better quality, but slower) (Recommended 4-6): " CPUPRESET
  read -p "Opus audio bitrate in kbps (Recommended 128k): " AUDIO_BITRATE
  read -p "How many columns of Tiles do you want? (2-4) (2 is balanced, 4 ideally uses 16 cores): " TILE_COLUMNS
  read -p "How many rows of Tiles do you want? (2-4) (2 is balanced, 4 ideally uses 16 cores): " TILE_ROWS

  read -p "Choose the directory name (it will be created if it doesn't exist): " DIR_OUTPUT
  echo "using directory "$PWD/"$DIR_OUTPUT"
  sleep 1
  mkdir -p "$DIR_OUTPUT"
  echo "Starting encode for the entire directory..."
  sleep 2
  for input in *.$container; do
    [ -e "$input" ] || continue

    filename="$(basename "$input")"
    filename="${filename%.*}"

    echo "Processing: \"$input\""
    sleep 2

    ffmpeg -i "$input" -threads 0 -c:v libaom-av1 -cpu-used $CPUPRESET -crf $CRF -pix_fmt yuv420p10le -aom-params "tile-columns=$TILE_COLUMNS:tile-rows=$TILE_ROWS:denoise-noise-level=$FILM_GRAIN:enable-dnl-denoising=$DENOISE_LEVEL" -c:a libopus -b:a $AUDIO_BITRATE -c:s copy "$DIR_OUTPUT/$filename[AV1].$container"
    beep -f 800 -l 200 -n -f 640
    sleep 2
    clear
    header
    # Show selected mode on line 4, column 6
  tput cup 4 7
  printf "\033[1;34m\e[5mMode: AOMENC - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # Shift change scroll region to line 6
  tput csr 6 $((`tput lines` - 6))
  # Place cursor in line 6, column 0
  tput cup 6 0
  echo -e "Encode finished, continuing with the next file..."
  sleep 2
    done
    Completed
    }

SVT_AV1_PSY_batch() {
clear
header
# Show selected mode on line 4, column 6
  tput cup 4 7
  printf "\033[1;34m\e[5mMode: SVT-AV1 - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # Shift change scroll region to line 6
  tput csr 6 $((`tput lines` - 6))
  # Place cursor in line 6, column 0
  tput cup 6 0
  echo "  === SVT-AV1-PSY Batch Encoder ==="
  echo -e "WRITE PARAMETERS MANUALLY, OTHERWISE THEY WILL NOT BE VALID"
  read -p "Desired CRF (0-63) (Recommended 19-21):" CRF
  read -p "Preset (0=best quality, 13=faster) (Recommended 4-6):" PRESET
  read -p "Opus audio bitrate in kbps (Recommended 128k):" AUDIO_BITRATE
  read -p "Choose the directory name (it will be created if it doesn't exist):" DIR_OUTPUT
  echo "using directory $PWD/"$DIR_OUTPUT""
  sleep 1
  mkdir -p "$DIR_OUTPUT"
  echo "Starting encode for the entire directory..."
  sleep 2
  for input in *.$container; do
    [ -e "$input" ] || continue

    filename="$(basename "$input")"
    filename="${filename%.*}"

    echo "Processing: \""$input"\""
    sleep 2

    ffmpeg -i "$input" -threads 0 -c:v libsvtav1 -preset $PRESET -crf $CRF -psy 1 -c:a libopus -b:a $AUDIO_BITRATE -c:s copy "$DIR_OUTPUT"/"$filename[AV1].$container"
    beep -f 800 -l 200 -n -f 640
    sleep 2
    # Place cursor in line 6, column 0
    tput cup 6 0
    sleep 2
    clear
    header
    # Show selected mode on line 4, column 6
  tput cup 4 7
  printf "\033[1;34m\e[5mMode: SVT-AV1 - Autoencode\033[0m"
  tput cup 5 0
  printf "======================================="
  # Shift change scroll region to line 6
  tput csr 6 $((`tput lines` - 6))
  # Place cursor in line 6, column 0
  tput cup 6 0
  echo -e "Encode finished, continuing with the next file..."
  sleep 2
    done
    Completed
    }
#  Start of the script
# ===================

header
#beep -f 932 -l 500 -D 700 -n -f 1244 -D 250 -n -f 932 -D 250 -n -f 1244 -n -f 1397 -n -f 1480
echo ""
echo -e "\033[93mThis script is under development and may have bugs.\033[39m"
echo ""
tput csr 5 $((`tput lines` - 5))
tput cup 7 0
Start_selection
