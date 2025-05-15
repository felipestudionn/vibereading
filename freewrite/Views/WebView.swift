// Swift 5.0
//
//  WebView.swift
//  freewrite (Vibe Reading)
//
//  Created on 5/15/25.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    var url: URL
    var height: CGFloat = 300
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Se puede usar para implementar lógica después de cargar la página
        }
    }
}
