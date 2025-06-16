#!/bin/bash

# Batch convert all PNG files in current directory to WebP
# Usage: ./convert-batch.sh [quality] [directory]

QUALITY="${1:-100}"
TARGET_DIR="${2:-.}"

echo "🔄 Batch converting PNG files to WebP..."
echo "📂 Directory: $TARGET_DIR"
echo "🎯 Quality: $QUALITY"
echo ""

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found!"
    exit 1
fi

# Count PNG files
PNG_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -name "*.png" | wc -l)

if [ "$PNG_COUNT" -eq 0 ]; then
    echo "No PNG files found in '$TARGET_DIR'"
    exit 0
fi

echo "Found $PNG_COUNT PNG file(s) to convert..."
echo ""

# Convert each PNG file
CONVERTED=0
TOTAL_ORIGINAL_SIZE=0
TOTAL_WEBP_SIZE=0

for PNG_FILE in "$TARGET_DIR"/*.png; do
    # Skip if no PNG files match the pattern
    [ ! -f "$PNG_FILE" ] && continue
    
    FILENAME=$(basename "$PNG_FILE")
    OUTPUT_FILE="${PNG_FILE%.png}.webp"
    
    echo "Converting: $FILENAME"
    
    if cwebp -q "$QUALITY" "$PNG_FILE" -o "$OUTPUT_FILE" 2>/dev/null; then
        ORIGINAL_SIZE=$(stat -f%z "$PNG_FILE")
        WEBP_SIZE=$(stat -f%z "$OUTPUT_FILE")
        
        TOTAL_ORIGINAL_SIZE=$((TOTAL_ORIGINAL_SIZE + ORIGINAL_SIZE))
        TOTAL_WEBP_SIZE=$((TOTAL_WEBP_SIZE + WEBP_SIZE))
        
        echo "  ✅ Success ($(numfmt --to=iec-i --suffix=B $ORIGINAL_SIZE) → $(numfmt --to=iec-i --suffix=B $WEBP_SIZE))"
        CONVERTED=$((CONVERTED + 1))
    else
        echo "  ❌ Failed"
    fi
done

echo ""
echo "📊 Conversion Summary:"
echo "  Converted: $CONVERTED/$PNG_COUNT files"

if [ "$CONVERTED" -gt 0 ]; then
    echo "  Total original size: $(numfmt --to=iec-i --suffix=B $TOTAL_ORIGINAL_SIZE)"
    echo "  Total WebP size: $(numfmt --to=iec-i --suffix=B $TOTAL_WEBP_SIZE)"
    
    if [ "$TOTAL_ORIGINAL_SIZE" -gt 0 ]; then
        TOTAL_REDUCTION=$(( (TOTAL_ORIGINAL_SIZE - TOTAL_WEBP_SIZE) * 100 / TOTAL_ORIGINAL_SIZE ))
        echo "  💾 Total size reduction: ${TOTAL_REDUCTION}%"
    fi
fi 