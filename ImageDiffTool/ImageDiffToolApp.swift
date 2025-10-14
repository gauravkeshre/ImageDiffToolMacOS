import SwiftUI

@main
struct ImageDiffToolApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(DefaultWindowStyle())
        .windowResizability(.contentSize)
    }
}