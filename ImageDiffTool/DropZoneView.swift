import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct DropZoneView: View {
    let isLeft: Bool
    @ObservedObject var viewModel: ImageViewModel
    @State private var isHovered = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isHovered ? Color.blue : Color.gray.opacity(0.5),
                    style: StrokeStyle(lineWidth: 2, dash: [5])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isHovered ? Color.blue.opacity(0.1) : Color.clear)
                )
            
            VStack(spacing: 16) {
                Image(systemName: "photo")
                    .font(.system(size: 48))
                    .foregroundColor(.gray)
                
                Text("Drop image here")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Supports: PNG, JPG, JPEG, GIF, TIFF, HEIC, WebP, BMP, ICO, AVIF")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(DropViewRepresentable(
            isLeft: isLeft,
            viewModel: viewModel,
            isHovered: $isHovered
        ))
    }
}

struct DropViewRepresentable: NSViewRepresentable {
    let isLeft: Bool
    @ObservedObject var viewModel: ImageViewModel
    @Binding var isHovered: Bool
    
    func makeNSView(context: Context) -> DropView {
        let dropView = DropView()
        dropView.isLeft = isLeft
        dropView.viewModel = viewModel
        dropView.onHoverChange = { hovered in
            isHovered = hovered
        }
        return dropView
    }
    
    func updateNSView(_ nsView: DropView, context: Context) {
        // Update if needed
    }
}

class DropView: NSView {
    var isLeft: Bool = true
    weak var viewModel: ImageViewModel?
    var onHoverChange: ((Bool) -> Void)?
    
    private let supportedTypes: [UTType] = [
        .png, .jpeg, .gif, .tiff, .heic, .webP, .bmp, .ico,
        UTType(filenameExtension: "jpg")!,
        UTType(filenameExtension: "jpe")!,
        UTType(filenameExtension: "jfif")!,
        UTType(filenameExtension: "tif")!,
        UTType(filenameExtension: "avif")!
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDragAndDrop()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupDragAndDrop()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDragAndDrop()
    }
    
    private func setupDragAndDrop() {
        registerForDraggedTypes([.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard
        
        guard let fileURLs = pasteboard.readObjects(forClasses: [NSURL.self]) as? [URL] else {
            return []
        }
        
        for url in fileURLs {
            if let uti = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType,
               supportedTypes.contains(where: { $0.conforms(to: uti) }) {
                onHoverChange?(true)
                return .copy
            }
        }
        
        return []
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        onHoverChange?(false)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        onHoverChange?(false)
        
        let pasteboard = sender.draggingPasteboard
        
        guard let fileURLs = pasteboard.readObjects(forClasses: [NSURL.self]) as? [URL],
              let url = fileURLs.first else {
            return false
        }
        
        // Verify it's a supported image format
        if let uti = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType,
           supportedTypes.contains(where: { $0.conforms(to: uti) }) {
            
            DispatchQueue.main.async {
                if self.isLeft {
                    self.viewModel?.setLeftImage(from: url)
                } else {
                    self.viewModel?.setRightImage(from: url)
                }
            }
            return true
        }
        
        return false
    }
}