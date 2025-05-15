// Swift 5.0
//
//  FreeWriteContentView.swift
//  freewrite (Vibe Reading)
//
//  Created on 5/15/25.
//

import SwiftUI

struct FreeWriteContentView: View {
    @Binding var selectedMode: AppMode?
    @Environment(\.colorScheme) var colorScheme
    @State private var isHoveringBackButton = false
    
    var body: some View {
        ZStack {
            // Contenido principal de FreeWrite (la aplicación original)
            ContentView()
            
            // Botón de regreso en la esquina superior izquierda
            VStack {
                HStack {
                    Button(action: {
                        selectedMode = nil
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16))
                            .foregroundColor(isHoveringBackButton ? 
                                            (colorScheme == .dark ? .white : .black) : 
                                            (colorScheme == .dark ? .gray : .gray))
                            .padding(8)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isHoveringBackButton = hovering
                        }
                    }
                    
                    Spacer()
                }
                .padding(12)
                
                Spacer()
            }
        }
    }
}

struct FreeWriteContentView_Previews: PreviewProvider {
    static var previews: some View {
        FreeWriteContentView(selectedMode: .constant(.writing))
    }
}
