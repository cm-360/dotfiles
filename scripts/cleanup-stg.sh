#!/bin/sh

# STG folder matching pattern
pattern="STG-backups-[[:alnum:]]+-[[:alnum:]]"
# Downloads folder path
downloads_folder="$HOME/Downloads"

# Find folders in downloads matching STG naming pattern
matching_folders=$(find "$downloads_folder" -type d | grep -E "$pattern")

# Remove all but the last 5 .json files
find $matching_folders -type f -name "*.json" | head -n -5 | xargs -d '\n' rm -f

# Remove empty STG folders
find $matching_folders -type d -empty -delete
