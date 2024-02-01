#!/bin/bash

set -e

if [ ! -z "$DEBUG" ]; then
	set -x
fi

# Configuration variables
# The easiest way to configure these, without breaking future script updates
# would be to create a new script where these variables are properly setup
GRAPHICS_PATH=${GRAPHICS_PATH:-"."}
EXPORT_PATH=${EXPORT_PATH:-"../SpineExport/"}
SPINE_VERSION=${SPINE_VERSION:-"4.1.24"}
EXPORT_SETTINGS=${EXPORT_SETTINGS:-"${GRAPHICS_PATH}/SpineExportDefault.export.json"}
SPINE_EXE=${SPINE_EXE:-""}

# try to auto detect spine executable path
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="C:/Program Files/Spine/Spine.com"
fi
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="/mnt/c/Program Files/Spine/Spine.com"
fi
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="/Applications/Spine.app/Contents/MacOS/Spine"
fi
if [ ! -f "$SPINE_EXE" ]; then
	SPINE_EXE="$HOME/Spine/Spine.sh"
fi
if [ ! -f "$SPINE_EXE" ]; then
	echo "Unable to find suitable spine executable. Please specify one in SPINE_EXE variable."
	exit 1
fi

# if no export settings file is presented use json+pack by default
if [ ! -f "$EXPORT_SETTINGS" ]; then
	EXPORT_SETTINGS="json+pack"
fi

echo "Spine exe: $SPINE_EXE"
echo "Spine version: $SPINE_VERSION"

spine_args=""
spine_args="${spine_args} -u $SPINE_VERSION"
spine_args="${spine_args} ${@:2}"

while IFS= read -r -d $'\0' file; do
	echo "Processing $file"
	setting_file="${file%.*}.export.json"
	if [ ! -f "${setting_file}" ]; then
		setting_file="${EXPORT_SETTINGS}"
	fi
	spine_args=$"${spine_args} -i $file -o `dirname ${EXPORT_PATH}/$file` -e ${setting_file}"

done < <(find "${GRAPHICS_PATH}" -iname \*.spine -type f -print0)





# Get the current path
current_path=$(pwd)

# List all directories in the current path
directories=$(ls -l $current_path | grep "^d" | awk '{print $NF}')

# Display the directories
echo "Directories in $current_path:"
echo "$directories"

# Iterate through each directory
for dir in $directories; do
    echo "Entering directory: $dir"
    cd "$current_path/$dir" || exit 1

    # Perform actions inside the directory
    # List files in the current directory and store them in an array
    files_in_dir=($(ls))

    echo "Files in $dir:"
    echo "${files_in_dir[@]}"

    # Print each file in a new line
    echo "  Files in $dir (on a new line):"
    for file in "${files_in_dir[@]}"; do
        echo "    $file"
    done

    # Return to the original directory
    cd "$current_path" || exit 1
done

echo "Processing Done."

"$SPINE_EXE" $spine_args
