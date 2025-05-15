//
//  freewriteApp.swift
//  freewrite (Vibe Reading)
//
//  Created by thorfinn on 2/14/25.
//  Modified on 5/15/25.
//

import SwiftUI

// Enum para los modos de la aplicación
enum AppMode {
    case reading
    case writing
}

@main
struct freewriteApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("colorScheme") private var colorSchemeString: String = "light"
    @State private var selectedMode: AppMode? = nil
    
    init() {
        // Register Lato font
        if let fontURL = Bundle.main.url(forResource: "Lato-Regular", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
     
    var body: some Scene {
        WindowGroup {
            Group {
                if selectedMode == nil {
                    StartView(selectedMode: $selectedMode)
                        .toolbar(.hidden, for: .windowToolbar)
                } else if selectedMode == .writing {
                    FreeWriteContentView(selectedMode: $selectedMode)
                        .toolbar(.hidden, for: .windowToolbar)
                } else if selectedMode == .reading {
                    ReadingView(selectedMode: $selectedMode)
                        .toolbar(.hidden, for: .windowToolbar)
                }
            }
            .preferredColorScheme(colorSchemeString == "dark" ? .dark : .light)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1100, height: 600)
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
    }
}

// Add AppDelegate to handle window configuration
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            // Ensure window starts in windowed mode
            if window.styleMask.contains(.fullScreen) {
                window.toggleFullScreen(nil)
            }
            
            // Center the window on the screen
            window.center()
        }
    }
} 
