#!/bin/bash

# Convert a single PNG/JPG file to WebP
# Usage: ./convert-single.sh input.png [quality]
#        ./convert-single.sh input.jpg [quality]

if [ $# -eq 0 ]; then
    echo "Usage: $0 <input.png|input.jpg> [quality]"
    echo "Example: $0 image.png 100"
    echo "Example: $0 photo.jpg 100"
    echo "Quality range: 0-100 (default: 100)"
    exit 1
fi

INPUT_FILE="$1"
QUALITY="${2:-100}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Check if input is a PNG or JPG file
if [[ ! "$INPUT_FILE" =~ \.(png|jpg|jpeg)$ ]]; then
    echo "Error: Input file must be a .png, .jpg, or .jpeg file!"
    exit 1
fi

# Generate output filename (remove original extension and add .webp)
if [[ "$INPUT_FILE" =~ \.png$ ]]; then
    OUTPUT_FILE="${INPUT_FILE%.png}.webp"
elif [[ "$INPUT_FILE" =~ \.jpg$ ]]; then
    OUTPUT_FILE="${INPUT_FILE%.jpg}.webp"
elif [[ "$INPUT_FILE" =~ \.jpeg$ ]]; then
    OUTPUT_FILE="${INPUT_FILE%.jpeg}.webp"
fi

# Convert the file
echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE' with quality $QUALITY..."
cwebp -q "$QUALITY" "$INPUT_FILE" -o "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Conversion successful!"
    echo "📁 Original: $(ls -lh "$INPUT_FILE" | awk '{print $5}')"
    echo "📁 WebP: $(ls -lh "$OUTPUT_FILE" | awk '{print $5}')"
    
    # Calculate size reduction
    ORIGINAL_SIZE=$(stat -f%z "$INPUT_FILE")
    WEBP_SIZE=$(stat -f%z "$OUTPUT_FILE")
    REDUCTION=$(( (ORIGINAL_SIZE - WEBP_SIZE) * 100 / ORIGINAL_SIZE ))
    echo "💾 Size reduction: ${REDUCTION}%"
else
    echo "❌ Conversion failed!"
    exit 1
fi 