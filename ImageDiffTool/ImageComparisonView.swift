//
//  ImageComparisonView.swift
//  ImageDiffTool
//
//  Created by Gaurav Keshre on 14/10/25.
//  Copyright © Gaurav Keshre. All rights reserved.
//

import SwiftUI
import AppKit

struct ImageComparisonView: View {
    let image: NSImage?
    let isLeft: Bool
    @ObservedObject var viewModel: ImageViewModel
    @State private var overlayOpacity: Double = 0.5
    @State private var isAnimating: Bool = false
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            if let image = displayImage {
                VStack {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    
                    // Overlay opacity control for overlay mode
                    if viewModel.comparisonMode == .overlay && !isLeft && viewModel.leftImage != nil && viewModel.rightImage != nil {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Opacity:")
                                Slider(value: $overlayOpacity, in: 0...1)
                                    .frame(maxWidth: 120)
                                    .disabled(isAnimating)
                                Text("\(Int(overlayOpacity * 100))%")
                                    .frame(width: 35)
                                
                                Button(action: toggleAnimation) {
                                    Image(systemName: isAnimating ? "pause.fill" : "play.fill")
                                        .foregroundColor(isAnimating ? .orange : .green)
                                }
                                .buttonStyle(.borderless)
                                .help(isAnimating ? "Stop animation" : "Start opacity animation loop")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                }
            } else {
                DropZoneView(isLeft: isLeft, viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func toggleAnimation() {
        if isAnimating {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        
        // Animate the slider value directly, which will update overlayOpacity
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            overlayOpacity = overlayOpacity < 0.5 ? 1.0 : 0.0
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        animationTimer?.invalidate()
        animationTimer = nil
        
        // Stop any ongoing animations
        withAnimation(.easeOut(duration: 0.3)) {
            // Keep current opacity value
        }
    }
    
    private var displayImage: NSImage? {
        switch viewModel.comparisonMode {
        case .sideBySide:
            return image
        case .overlay:
            if isLeft {
                return image
            } else if let rightImage = viewModel.rightImage, let leftImage = viewModel.leftImage {
                return createOverlayImage(base: leftImage, overlay: rightImage, opacity: overlayOpacity)
            }
            return image
        case .difference:
            if isLeft {
                return image
            } else {
                return viewModel.differenceImage ?? image
            }
            case .onionSkin:
                return nil
        }
    }
    
    private func createOverlayImage(base: NSImage, overlay: NSImage, opacity: Double) -> NSImage? {
        let size = NSSize(width: min(base.size.width, overlay.size.width),
                         height: min(base.size.height, overlay.size.height))
        
        let overlayImage = NSImage(size: size)
        overlayImage.lockFocus()
        
        // Draw base image
        base.draw(in: NSRect(origin: .zero, size: size))
        
        // Draw overlay with opacity
        overlay.draw(in: NSRect(origin: .zero, size: size), 
                    from: NSRect(origin: .zero, size: overlay.size),
                    operation: .sourceOver, 
                    fraction: opacity)
        
        overlayImage.unlockFocus()
        return overlayImage
    }
}
