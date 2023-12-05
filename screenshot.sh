#!/bin/bash

# Need to install imagemagick
# If you want to use monitor script, set default screenshot
# directory to $HOME/screenshots
#
# screenshot.sh
#
# Adds a fancy background, of your choice.
# Copys the new image to your clipboard.
#
# Update file locations as needed

# Variables
FILE_LOC=$1
NAME=$(basename "$FILE_LOC")
SCSHT_DIR=$HOME/screenshots
MODIFY_DIR="$SCSHT_DIR/modded"
FINAL_LOC="$MODIFY_DIR/$NAME"

mkdir -p $SCH_DIR $MODIFY_DIR

BG_IMG=$SCSHT_DIR/imgback.png
BG_PADDING=80

# Calculations
read WIDTH HEIGHT < <(identify -format "%w %h" $FILE_LOC)
NEW_WIDTH=$((WIDTH + BG_PADDING))
NEW_HEIGHT=$((HEIGHT + BG_PADDING))

# Put dropshadow on img
magick $FILE_LOC -alpha set \
	\( +clone -background black -shadow 80x0+10+10 \) +swap \
	-background none -mosaic /tmp/tmpscreenshot.png

# Resize our bg img so screenshot fits on it with padding
convert $BG_IMG -resize ${NEW_WIDTH}x${NEW_HEIGHT}^ \
	-gravity center -extent ${NEW_WIDTH}x${NEW_HEIGHT} \
	/tmp/background.png

# Put the image on the background
convert /tmp/background.png /tmp/tmpscreenshot.png \
	-gravity center -composite $FINAL_LOC

osascript -e "set the clipboard to (read (POSIX file \"$FINAL_LOC\") as JPEG picture)"
