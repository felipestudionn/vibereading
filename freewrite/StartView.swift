// Swift 5.0
//
//  StartView.swift
//  freewrite (Vibe Reading)
//
//  Created on 5/15/25.
//

import SwiftUI

struct StartView: View {
    @Binding var selectedMode: AppMode?
    @Environment(\.colorScheme) var colorScheme
    
    @State private var hoveringWrite = false
    @State private var hoveringRead = false
    
    var body: some View {
        ZStack {
            // Fondo
            (colorScheme == .dark ? Color.black : Color.white)
                .edgesIgnoringSafeArea(.all)
            
            // Opciones minimalistas en una sola línea horizontal
            HStack(spacing: 0) {
                // Botón Writing
                Button(action: {
                    selectedMode = .writing
                }) {
                    Text("Writing")
                        .font(.custom("Lato-Regular", size: 18))
                        .fontWeight(.light)
                        .foregroundColor(hoveringWrite ? 
                                        (colorScheme == .dark ? .white : .black) : 
                                        (colorScheme == .dark ? .gray : .gray))
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        hoveringWrite = hovering
                    }
                }
                
                // Separador
                Text("    ·    ")
                    .font(.custom("Lato-Regular", size: 18))
                    .fontWeight(.light)
                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
                
                // Botón Reading
                Button(action: {
                    selectedMode = .reading
                }) {
                    Text("Reading")
                        .font(.custom("Lato-Regular", size: 18))
                        .fontWeight(.light)
                        .foregroundColor(hoveringRead ? 
                                        (colorScheme == .dark ? .white : .black) : 
                                        (colorScheme == .dark ? .gray : .gray))
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        hoveringRead = hovering
                    }
                }
            }
        }
    }
}

// Vista previa para StartView
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartView(selectedMode: .constant(nil))
                .preferredColorScheme(.light)
            
            StartView(selectedMode: .constant(nil))
                .preferredColorScheme(.dark)
        }
    }
}
