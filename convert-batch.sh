#!/bin/bash

# Batch convert all PNG/JPG files in current directory to WebP
# Usage: ./convert-batch.sh [quality] [directory]

# Function to convert bytes to human readable format
format_bytes() {
    local bytes=$1
    if [ $bytes -lt 1024 ]; then
        echo "${bytes}B"
    elif [ $bytes -lt 1048576 ]; then
        echo "$(( (bytes + 512) / 1024 ))K"
    elif [ $bytes -lt 1073741824 ]; then
        echo "$(( (bytes + 524288) / 1048576 ))M"
    else
        echo "$(( (bytes + 536870912) / 1073741824 ))G"
    fi
}

QUALITY="${1:-100}"
TARGET_DIR="${2:-.}"

echo "🔄 Batch converting PNG/JPG files to WebP..."
echo "📂 Directory: $TARGET_DIR"
echo "🎯 Quality: $QUALITY"
echo ""

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found!"
    exit 1
fi

# Count image files
PNG_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -name "*.png" | wc -l)
JPG_COUNT=$(find "$TARGET_DIR" -maxdepth 1 \( -name "*.jpg" -o -name "*.jpeg" \) | wc -l)
TOTAL_COUNT=$((PNG_COUNT + JPG_COUNT))

if [ "$TOTAL_COUNT" -eq 0 ]; then
    echo "No PNG/JPG files found in '$TARGET_DIR'"
    exit 0
fi

echo "Found $TOTAL_COUNT image file(s) to convert ($PNG_COUNT PNG, $JPG_COUNT JPG/JPEG)..."
echo ""

# Convert each image file
CONVERTED=0
TOTAL_ORIGINAL_SIZE=0
TOTAL_WEBP_SIZE=0

# Function to convert a single file
convert_file() {
    local input_file="$1"
    local filename=$(basename "$input_file")
    local output_file
    
    # Generate output filename based on extension
    if [[ "$input_file" =~ \.png$ ]]; then
        output_file="${input_file%.png}.webp"
    elif [[ "$input_file" =~ \.jpg$ ]]; then
        output_file="${input_file%.jpg}.webp"
    elif [[ "$input_file" =~ \.jpeg$ ]]; then
        output_file="${input_file%.jpeg}.webp"
    fi
    
    echo "Converting: $filename"
    
    if cwebp -q "$QUALITY" "$input_file" -o "$output_file" 2>/dev/null; then
        local original_size=$(stat -f%z "$input_file")
        local webp_size=$(stat -f%z "$output_file")
        
        TOTAL_ORIGINAL_SIZE=$((TOTAL_ORIGINAL_SIZE + original_size))
        TOTAL_WEBP_SIZE=$((TOTAL_WEBP_SIZE + webp_size))
        
        echo "  ✅ Success ($(format_bytes $original_size) → $(format_bytes $webp_size))"
        CONVERTED=$((CONVERTED + 1))
    else
        echo "  ❌ Failed"
    fi
}

# Process PNG files
for PNG_FILE in "$TARGET_DIR"/*.png; do
    [ ! -f "$PNG_FILE" ] && continue
    convert_file "$PNG_FILE"
done

# Process JPG files
for JPG_FILE in "$TARGET_DIR"/*.jpg "$TARGET_DIR"/*.jpeg; do
    [ ! -f "$JPG_FILE" ] && continue
    convert_file "$JPG_FILE"
done

echo ""
echo "📊 Conversion Summary:"
echo "  Converted: $CONVERTED/$TOTAL_COUNT files"

if [ "$CONVERTED" -gt 0 ]; then
    echo "  Total original size: $(format_bytes $TOTAL_ORIGINAL_SIZE)"
    echo "  Total WebP size: $(format_bytes $TOTAL_WEBP_SIZE)"
    
    if [ "$TOTAL_ORIGINAL_SIZE" -gt 0 ]; then
        TOTAL_REDUCTION=$(( (TOTAL_ORIGINAL_SIZE - TOTAL_WEBP_SIZE) * 100 / TOTAL_ORIGINAL_SIZE ))
        echo "  💾 Total size reduction: ${TOTAL_REDUCTION}%"
    fi
fi 