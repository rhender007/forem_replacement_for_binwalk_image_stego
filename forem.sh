#!/bin/bash

# Ensure the script is being run with a file argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_image_file>"
    exit 1
fi

# Get the input file from arguments
IMAGE_FILE="$1"

# Ensure the file exists
if [ ! -f "$IMAGE_FILE" ]; then
    echo "Error: File '$IMAGE_FILE' not found!"
    exit 1
fi

# Check if foremost is installed
if ! command -v foremost &> /dev/null; then
    echo "Foremost is not installed. Install it with 'sudo apt-get install foremost'."
    exit 1
fi

# Create output directory based on the file name
OUTPUT_DIR="${IMAGE_FILE%.*}_foremost_output"

# Run foremost to extract files
echo "Running foremost on $IMAGE_FILE..."
foremost -i "$IMAGE_FILE" -o "$OUTPUT_DIR"

if [ $? -ne 0 ]; then
    echo "Foremost extraction failed. Check if the file is valid."
    exit 1
fi

echo "Extraction complete. Files saved in $OUTPUT_DIR."

# Detect WSL2 and handle accordingly
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    echo "Detected WSL. Using Windows' default image viewer..."
    for IMAGE in $(find "$OUTPUT_DIR" -type f \( -name "*.jpg" -o -name "*.png" \)); do
        explorer.exe "$(wslpath -w "$IMAGE")"
    done
else
    # Open images with eog/eom if not WSL
    IMAGE_VIEWER=""
    if command -v eog &> /dev/null; then
        IMAGE_VIEWER="eog"
    elif command -v eom &> /dev/null; then
        IMAGE_VIEWER="eom"
    else
        echo "No supported image viewer (eog or eom) found. Install one to view images automatically."
    fi

    if [ -n "$IMAGE_VIEWER" ]; then
        echo "Opening extracted images in $IMAGE_VIEWER..."
        find "$OUTPUT_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) -exec "$IMAGE_VIEWER" {} +
    fi
fi

# List the contents of the output folder
echo "Extracted files:"
ls -l "$OUTPUT_DIR"

