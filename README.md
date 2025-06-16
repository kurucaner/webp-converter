# 🖼️ WebP Converter

A simple and efficient command-line tool to convert PNG files to WebP format on macOS. Supports both single file and batch conversion with customizable quality settings.

## ✨ Features

- 🔄 **Single file conversion** - Convert one PNG file at a time
- 📁 **Batch conversion** - Convert all PNG files in a directory
- 🎯 **Quality control** - Adjustable quality from 0-100
- 📊 **Size comparison** - Shows file size reduction after conversion
- 🖥️ **Interactive mode** - User-friendly menu interface
- ⚡ **Fast processing** - Uses Google's official WebP tools

## 🛠️ Prerequisites

### Install WebP Tools

**Using Homebrew (Recommended):**

```bash
brew install webp
```

**Using MacPorts:**

```bash
sudo port install webp
```

**Verify Installation:**

```bash
cwebp -version
```

You should see something like:

```
1.5.0
libsharpyuv: 0.4.1
```

## 🚀 Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/webp-converter.git
   cd webp-converter
   ```

2. **Make scripts executable:**

   ```bash
   chmod +x convert-single.sh convert-batch.sh webp-converter
   ```

3. **You're ready to go!** 🎉

## 📖 Usage

### Main Tool: `webp-converter` (Recommended)

**Interactive Mode:**

```bash
./webp-converter
```

**Command Line Options:**

```bash
# Convert single file
./webp-converter -f image.png

# Convert with custom quality
./webp-converter -f image.png -q 90

# Convert all PNGs in a directory
./webp-converter -d ./photos

# Convert with custom quality and directory
./webp-converter -d ./photos -q 85

# Show help
./webp-converter --help
```

### Individual Scripts

**Single File Converter:**

```bash
# Default quality (80)
./convert-single.sh image.png

# Custom quality
./convert-single.sh image.png 90
```

**Batch Converter:**

```bash
# Current directory, default quality
./convert-batch.sh

# Custom quality
./convert-batch.sh 85

# Specific directory with custom quality
./convert-batch.sh 90 ./photos
```

## 🎯 Quality Guide

| Quality Range | Description                   | Use Case                           |
| ------------- | ----------------------------- | ---------------------------------- |
| 90-100        | Highest quality, larger files | Professional photos, print quality |
| 80-89         | High quality (recommended)    | Web images, general use            |
| 70-79         | Good quality, smaller files   | Fast loading web images            |
| 0-69          | Lower quality, smallest files | Thumbnails, icons                  |

## 📊 Example Output

```bash
$ ./webp-converter -f screenshot.png -q 85

🔄 Converting 'screenshot.png' to 'screenshot.webp' with quality 85...
Saving file 'screenshot.webp'
File:      screenshot.png
Dimension: 1920 x 1080
Output:    2074664 bytes Y-U-V-All-PSNR 45.82 46.54 47.89   46.08 dB
           (1.08 bpp)
block count:  intra4: 3847
              intra16: 37680  (-> 90.74%)
              skipped block: 27230 (65.66%)
bytes used:  header:          7938  (0.4%)
             mode-partition: 273550  (13.2%)
             Residuals:     1793176  (86.4%)
Segmentation: 92% quality, 2 segments, lambda=44
✅ Conversion successful!
📁 Original: 3.2M
📁 WebP: 2.0M
💾 Size reduction: 37%
```

## 🔧 Troubleshooting

### WebP tools not found

```bash
Error: cwebp command not found
```

**Solution:** Install WebP tools using Homebrew:

```bash
brew install webp
```

### Permission denied

```bash
Permission denied: ./webp-converter
```

**Solution:** Make the script executable:

```bash
chmod +x webp-converter
```

### Script not found

```bash
No such file or directory
```

**Solution:** Make sure you're in the correct directory:

```bash
cd webp-converter
ls -la *.sh webp-converter
```

## 📁 Project Structure

```
webp-converter/
├── README.md              # This file
├── webp-converter         # Main interactive tool
├── convert-single.sh      # Single file converter
└── convert-batch.sh       # Batch converter
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Google for the excellent [WebP](https://developers.google.com/speed/webp) image format and tools
- The open-source community for inspiration and feedback

---

**Happy converting! 🎉**

For questions or issues, please open an issue on GitHub.
