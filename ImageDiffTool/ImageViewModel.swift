//
//  ImageViewModel.swift
//  ImageDiffTool
//
//  Created by Gaurav Keshre on 14/10/25.
//  Copyright © Gaurav Keshre. All rights reserved.
//

import SwiftUI
import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum ComparisonMode {
    case sideBySide
    case overlay
    case difference
    case onionSkin
}

class ImageViewModel: ObservableObject {
    @Published var leftImage: NSImage?
    @Published var rightImage: NSImage?
    @Published var leftImagePath: String = ""
    @Published var rightImagePath: String = ""
    @Published var comparisonMode: ComparisonMode = .sideBySide
    @Published var isComparing: Bool = false
    @Published var differenceImage: NSImage?
    
    var canCompare: Bool {
        return leftImage != nil && rightImage != nil
    }
    
    func setLeftImage(from url: URL) {
        guard let image = NSImage(contentsOf: url) else {
            print("Failed to load image from: \(url)")
            return
        }
        
        DispatchQueue.main.async {
            self.leftImage = image
            self.leftImagePath = url.lastPathComponent
        }
    }
    
    func setRightImage(from url: URL) {
        guard let image = NSImage(contentsOf: url) else {
            print("Failed to load image from: \(url)")
            return
        }
        
        DispatchQueue.main.async {
            self.rightImage = image
            self.rightImagePath = url.lastPathComponent
        }
    }
    
    func performComparison() {
        guard let leftImage = leftImage,
              let rightImage = rightImage else {
            return
        }
        
        isComparing = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let difference = self.createDifferenceImage(left: leftImage, right: rightImage)
            
            DispatchQueue.main.async {
                self.differenceImage = difference
                self.isComparing = false
            }
        }
    }
    
    private func createDifferenceImage(left: NSImage, right: NSImage) -> NSImage? {
        // Convert NSImages to CIImages
        guard let leftCGImage = left.cgImage(forProposedRect: nil, context: nil, hints: nil),
              let rightCGImage = right.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let leftCIImage = CIImage(cgImage: leftCGImage)
        let rightCIImage = CIImage(cgImage: rightCGImage)
        
        // Resize images to the same dimensions if needed
        let targetSize = CGSize(
            width: min(leftCIImage.extent.width, rightCIImage.extent.width),
            height: min(leftCIImage.extent.height, rightCIImage.extent.height)
        )
        
        let resizedLeft = leftCIImage.transformed(by: CGAffineTransform(
            scaleX: targetSize.width / leftCIImage.extent.width,
            y: targetSize.height / leftCIImage.extent.height
        ))
        
        let resizedRight = rightCIImage.transformed(by: CGAffineTransform(
            scaleX: targetSize.width / rightCIImage.extent.width,
            y: targetSize.height / rightCIImage.extent.height
        ))
        
        // Create difference using blend modes
        let context = CIContext()
        
        // Use difference blend mode
        let differenceFilter = CIFilter.differenceBlendMode()
        differenceFilter.inputImage = resizedLeft
        differenceFilter.backgroundImage = resizedRight
        
        guard let outputImage = differenceFilter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
        return nsImage
    }
    
    func clearImages() {
        leftImage = nil
        rightImage = nil
        leftImagePath = ""
        rightImagePath = ""
        differenceImage = nil
    }
    
    func exportDifference() -> URL? {
        guard let differenceImage = differenceImage else { return nil }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.nameFieldStringValue = "image_difference.png"
        
        if savePanel.runModal() == .OK,
           let url = savePanel.url {
            
            // Convert NSImage to PNG and save
            if let tiffData = differenceImage.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData),
               let pngData = bitmap.representation(using: .png, properties: [:]) {
                
                try? pngData.write(to: url)
                return url
            }
        }
        
        return nil
    }
}