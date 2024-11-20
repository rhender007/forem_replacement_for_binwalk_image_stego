# Forem: File Extraction Utility using Foremost

`forem` is a simple utility script that uses `foremost` to extract embedded files from a host file. It supports automatic extraction of common file types (e.g., images, videos) and opens any extracted images for quick analysis.

---

## Features

- Automatically extracts files using `foremost`.
- Extracted files are saved in an organized output folder.
- Automatically opens extracted images (e.g., `.jpg`, `.png`) in an image viewer (`eog` or `eom`).
- Provides a summary of extracted files.

---

## Prerequisites

### Foremost
Install `foremost` to enable file extraction:
```bash
# sudo apt-get install foremost

chmod +x forem.sh
# Copy it to /usr/local/bin for global use:
sudo cp forem.sh /usr/local/bin/forem

# test it
forem image.jpg
