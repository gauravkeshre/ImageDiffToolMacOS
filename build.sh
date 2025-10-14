#!/bin/bash

# Build script for Image Diff Tool
# Usage: ./build.sh [clean|release]

set -e

PROJECT_NAME="ImageDiffTool"
SCHEME_NAME="ImageDiffTool"

echo "🔨 Building $PROJECT_NAME..."

case "$1" in
    "clean")
        echo "🧹 Cleaning project..."
        xcodebuild clean -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME_NAME"
        ;;
    "release")
        echo "📦 Building release version..."
        xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME_NAME" -configuration Release -arch x86_64 -arch arm64
        echo "✅ Release build completed!"
        echo "📁 App location: $(pwd)/build/Release/$PROJECT_NAME.app"
        ;;
    *)
        echo "🔄 Building debug version..."
        xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME_NAME" -configuration Debug
        echo "✅ Debug build completed!"
        echo "🚀 To run: open build/Debug/$PROJECT_NAME.app"
        ;;
esac

echo "🎉 Build process finished!"