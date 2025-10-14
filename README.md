# Image Diff Tool

A simple and elegant macOS application for visually comparing images with drag-and-drop functionality.

![Image Diff Tool Screenshot](screenshot.png)

*The app features a clean, dark-themed interface with split-view panels for side-by-side image comparison, multiple comparison modes, and intuitive drag-and-drop functionality.*

## Features

- **Drag & Drop Interface**: Simply drag images into the left and right panels
- **Multiple Comparison Modes**:
  - Side by Side: View images side by side for manual comparison
  - Overlay: Overlay one image on top of the other with adjustable opacity
  - Difference: Generate a visual difference highlighting changed pixels
- **Wide Format Support**: Supports PNG, JPG, JPEG, GIF, TIFF, HEIC, WebP, BMP, ICO, AVIF
- **Export Functionality**: Save difference images as PNG files
- **Clean, Minimal UI**: Inspired by modern diff tools with a dark theme

## Screenshots

The application features a modern, intuitive interface:

- **Main Interface**: Split-view design with left and right image panels
- **Drop Zones**: Clear visual indicators for drag-and-drop functionality
- **Mode Selection**: Easy switching between Side by Side, Overlay, and Difference modes
- **Control Bar**: Compare, Export Difference, and Clear buttons for workflow management
- **File Path Display**: Shows the names of currently loaded images

## Supported Image Formats

- PNG (.png)
- JPEG (.jpg, .jpeg, .jpe, .jfif)
- GIF (.gif)
- TIFF (.tiff, .tif)
- HEIC (.heic)
- WebP (.webp)
- BMP (.bmp)
- ICO (.ico)
- AVIF (.avif)

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building from source)

## Quick Start

### Option 1: Download Pre-built App (Coming Soon)
A pre-built version will be available for download. Simply download the `.app` file and drag it to your Applications folder.

### Option 2: Build from Source

#### Building the App from Source

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /Users/gauravkeshre/Downloads/ImageDiffTool
   ```

2. Open the project in Xcode:
   ```bash
   open ImageDiffTool.xcodeproj
   ```

3. In Xcode:
   - Select your development team in the project settings if needed
   - Choose "ImageDiffTool" scheme and "My Mac" as the destination
   - Press Cmd+R to build and run

## How to Use

1. **Launch the Application**: Run the app from Xcode or after building
2. **Load Images**: 
   - Drag an image file into the "Left" panel
   - Drag another image file into the "Right" panel
3. **Choose Comparison Mode**:
   - **Side by Side**: Default mode for manual comparison
   - **Overlay**: Blend images with adjustable opacity slider
   - **Difference**: Generate pixel-level difference visualization
4. **Compare**: Click the "Compare" button to process the images
5. **Export**: Use "Export Difference" to save the difference image
6. **Clear**: Use "Clear" to start over with new images

## Technical Details

- Built with SwiftUI for modern macOS development
- Uses Core Image for advanced image processing and difference generation
- Implements proper drag-and-drop using NSView and UTType system
- Sandboxed application with appropriate entitlements for file access

## Architecture

- `ContentView.swift`: Main application interface
- `ImageComparisonView.swift`: Individual image panel component
- `DropZoneView.swift`: Drag-and-drop handling and visual feedback
- `ImageViewModel.swift`: Core business logic and image processing
- `ImageDiffToolApp.swift`: Application entry point

## Future Enhancements

- Zoom and pan functionality
- Histogram comparison
- Batch processing
- Additional blend modes
- Keyboard shortcuts
- Preference settings

## Adding Screenshots

To add your own screenshot to this README:

1. Run the app and take a screenshot (Cmd+Shift+4, then Spacebar to capture the window)
2. Save it as `screenshot.png` in the project root directory
3. The README already references the image with: `![Image Diff Tool Screenshot](screenshot.png)`
4. Or run `./screenshot-guide.sh` for detailed instructions

## License

This project is provided as-is for educational and personal use.