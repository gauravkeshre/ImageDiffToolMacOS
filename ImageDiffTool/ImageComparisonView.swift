import SwiftUI
import AppKit

struct ImageComparisonView: View {
    let image: NSImage?
    let isLeft: Bool
    @ObservedObject var viewModel: ImageViewModel
    @State private var overlayOpacity: Double = 0.5
    
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
                        HStack {
                            Text("Opacity:")
                            Slider(value: $overlayOpacity, in: 0...1)
                                .frame(maxWidth: 150)
                            Text("\(Int(overlayOpacity * 100))%")
                                .frame(width: 35)
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
