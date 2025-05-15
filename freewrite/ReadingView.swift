// Swift 5.0
//
//  ReadingView.swift
//  freewrite (Vibe Reading)
//
//  Created on 5/15/25.
//

import SwiftUI

struct ReadingView: View {
    @Binding var selectedMode: AppMode?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            // Barra superior con título y botón de regreso
            HStack {
                Button(action: {
                    selectedMode = nil
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 14))
                        Text("Inicio")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Text("Modo Lectura")
                    .font(.custom("Lato-Regular", size: 18))
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            
            // Contenido principal - Marcador de posición
            VStack(spacing: 20) {
                Spacer()
                
                Text("Funcionalidad de lectura en desarrollo")
                    .font(.custom("Lato-Regular", size: 24))
                    .multilineTextAlignment(.center)
                
                Text("Esta sección se implementará próximamente")
                    .font(.custom("Lato-Regular", size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
    }
}

// Vista previa para ReadingView
struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView(selectedMode: .constant(.reading))
    }
}
