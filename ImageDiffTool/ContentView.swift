//
//  ContentView.swift
//  ImageDiffTool
//
//  Created by Gaurav Keshre on 14/10/25.
//  Copyright © Gaurav Keshre. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ImageViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with file path displays
            HStack {
                // Left file path
                HStack {
                    Text("Left...")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.6))
                        .cornerRadius(6)
                    
                    Text(viewModel.leftImagePath)
                        .foregroundColor(.white)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                
                // Right file path
                HStack {
                    Text("Right...")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.6))
                        .cornerRadius(6)
                    
                    Text(viewModel.rightImagePath)
                        .foregroundColor(.white)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor).opacity(0.9))
            
            // Main comparison area
            HStack(spacing: 1) {
                // Left panel
                VStack(spacing: 0) {
                    Text("Left")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    ImageComparisonView(
                        image: viewModel.leftImage,
                        isLeft: true,
                        viewModel: viewModel
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.8))
                
                // Separator
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 1)
                
                // Right panel
                VStack(spacing: 0) {
                    Text("Right")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    ImageComparisonView(
                        image: viewModel.rightImage,
                        isLeft: false,
                        viewModel: viewModel
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.8))
            }
            
            // Bottom control bar
            HStack {
                // Comparison mode picker
                Picker("Mode", selection: $viewModel.comparisonMode) {
                    Text("Side by Side").tag(ComparisonMode.sideBySide)
                    Text("Overlay").tag(ComparisonMode.overlay)
                    Text("Difference").tag(ComparisonMode.difference)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
                
                Spacer()
                
                // Compare button
                Button("Compare") {
                    viewModel.performComparison()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canCompare)
                
                Spacer()
                
                // Export button
                Button("Export Difference") {
                    _ = viewModel.exportDifference()
                }
                .disabled(viewModel.differenceImage == nil)
                
                // Clear button
                Button("Clear") {
                    viewModel.clearImages()
                }
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor).opacity(0.9))
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
    }
}

#Preview {
    ContentView()
}