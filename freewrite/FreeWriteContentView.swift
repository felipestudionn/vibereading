// Swift 5.0
//
//  FreeWriteContentView.swift
//  freewrite (Vibe Reading)
//
//  Created on 5/15/25.
//

import SwiftUI
import AppKit

struct FreeWriteContentView: View {
    @Binding var selectedMode: AppMode?
    @Environment(\.colorScheme) var colorScheme
    @State private var isHoveringBackButton = false
    
    // Estados para elementos sensoriales
    @State private var showingSensoryControls = false
    @State private var isHoveringMusic = false
    @State private var isHoveringPhoto = false
    @State private var showingSpotifyInput = false
    @State private var showingPinterestInput = false
    @State private var spotifyURL = ""
    @State private var spotifyTitle = ""
    @State private var pinterestURL = ""
    @State private var pinterestTitle = ""
    
    // Estado para el documento actual y su gestión
    @State private var currentDocument = EnrichedDocument.empty()
    @State private var sensoryElements: [SensoryElement] = []
    
    var body: some View {
        ZStack {
            // Contenido principal de FreeWrite (la aplicación original)
            ContentView()
            
            // Marcadores visuales para elementos sensoriales (en el margen izquierdo)
            if !sensoryElements.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(sensoryElements) { element in
                        HStack(spacing: 0) {
                            // Indicador de elemento sensorial
                            Image(systemName: element.type == .spotify ? "music.note" : "photo")
                                .font(.system(size: 10))
                                .foregroundColor(colorScheme == .dark ? .gray : .gray)
                                .frame(width: 20, height: 20)
                                .background(colorScheme == .dark ? Color.black : Color.white)
                        }
                        .padding(.top, 100 + CGFloat(sensoryElements.firstIndex(where: { $0.id == element.id }) ?? 0) * 30)
                        .padding(.leading, 10)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            
            // Overlay para controles de navegación y elementos sensoriales
            VStack(spacing: 0) {
                // Barra superior con botón de regreso
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
                    
                    // Botón para mostrar/ocultar controles sensoriales
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showingSensoryControls.toggle()
                        }
                    }) {
                        Image(systemName: showingSensoryControls ? "xmark" : "plus")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .gray : .gray)
                            .padding(8)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 8)
                }
                .padding(12)
                
                Spacer()
                
                // Panel lateral para añadir elementos sensoriales
                if showingSensoryControls {
                    VStack(spacing: 16) {
                        // Botón para Spotify
                        Button(action: {
                            showingSpotifyInput = true
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "music.note")
                                    .font(.system(size: 16))
                                    .foregroundColor(isHoveringMusic ? 
                                                   (colorScheme == .dark ? .white : .black) : 
                                                   (colorScheme == .dark ? .gray : .gray))
                                Text("Spotify")
                                    .font(.custom("Lato-Regular", size: 10))
                                    .foregroundColor(isHoveringMusic ? 
                                                   (colorScheme == .dark ? .white : .black) : 
                                                   (colorScheme == .dark ? .gray : .gray))
                            }
                            .padding(10)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .cornerRadius(6)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { hovering in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isHoveringMusic = hovering
                            }
                        }
                        .popover(isPresented: $showingSpotifyInput) {
                            SpotifyInputView(spotifyURL: $spotifyURL, spotifyTitle: $spotifyTitle, isPresented: $showingSpotifyInput, onAdd: addSpotifyElement)
                        }
                        
                        // Botón para Pinterest
                        Button(action: {
                            showingPinterestInput = true
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .font(.system(size: 16))
                                    .foregroundColor(isHoveringPhoto ? 
                                                   (colorScheme == .dark ? .white : .black) : 
                                                   (colorScheme == .dark ? .gray : .gray))
                                Text("Pinterest")
                                    .font(.custom("Lato-Regular", size: 10))
                                    .foregroundColor(isHoveringPhoto ? 
                                                   (colorScheme == .dark ? .white : .black) : 
                                                   (colorScheme == .dark ? .gray : .gray))
                            }
                            .padding(10)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .cornerRadius(6)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { hovering in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isHoveringPhoto = hovering
                            }
                        }
                        .popover(isPresented: $showingPinterestInput) {
                            PinterestInputView(pinterestURL: $pinterestURL, pinterestTitle: $pinterestTitle, isPresented: $showingPinterestInput, onAdd: addPinterestElement)
                        }
                    }
                    .padding(12)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 4)
                    .padding(.trailing, 12)
                    .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

// Funciones para añadir elementos sensoriales
extension FreeWriteContentView {
    // Añadir elemento Spotify
    func addSpotifyElement() {
        guard !spotifyURL.isEmpty, !spotifyTitle.isEmpty else { return }
        
        // En una implementación real, aquí obtendríamos la posición actual del cursor
        // Para este ejemplo, usamos una posición simulada
        let cursorPosition = 100
        
        let newElement = SensoryElement(
            id: UUID(),
            type: .spotify,
            url: spotifyURL,
            title: spotifyTitle,
            position: cursorPosition
        )
        
        sensoryElements.append(newElement)
        
        // Limpiar los campos
        spotifyURL = ""
        spotifyTitle = ""
        showingSpotifyInput = false
    }
    
    // Añadir elemento Pinterest
    func addPinterestElement() {
        guard !pinterestURL.isEmpty, !pinterestTitle.isEmpty else { return }
        
        // En una implementación real, aquí obtendríamos la posición actual del cursor
        // Para este ejemplo, usamos una posición simulada
        let cursorPosition = 200
        
        let newElement = SensoryElement(
            id: UUID(),
            type: .pinterest,
            url: pinterestURL,
            title: pinterestTitle,
            position: cursorPosition
        )
        
        sensoryElements.append(newElement)
        
        // Limpiar los campos
        pinterestURL = ""
        pinterestTitle = ""
        showingPinterestInput = false
    }
}

// Vista para ingresar URL de Spotify
struct SpotifyInputView: View {
    @Binding var spotifyURL: String
    @Binding var spotifyTitle: String
    @Binding var isPresented: Bool
    var onAdd: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isURLFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Añadir música de Spotify")
                .font(.custom("Lato-Regular", size: 14))
                .fontWeight(.medium)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Título")
                    .font(.custom("Lato-Regular", size: 12))
                    .foregroundColor(.gray)
                
                TextField("Título descriptivo", text: $spotifyTitle)
                    .font(.custom("Lato-Regular", size: 14))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("URL de Spotify")
                    .font(.custom("Lato-Regular", size: 12))
                    .foregroundColor(.gray)
                
                TextField("https://open.spotify.com/...", text: $spotifyURL)
                    .font(.custom("Lato-Regular", size: 14))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                    .cornerRadius(4)
                    .focused($isURLFocused)
            }
            
            HStack {
                Spacer()
                
                Button("Cancelar") {
                    isPresented = false
                }
                .font(.custom("Lato-Regular", size: 14))
                .foregroundColor(.gray)
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 12)
                
                Button("Añadir") {
                    onAdd()
                }
                .font(.custom("Lato-Regular", size: 14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 12)
                .disabled(spotifyURL.isEmpty || spotifyTitle.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 300)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onAppear {
            isURLFocused = true
        }
    }
}

// Vista para ingresar URL de Pinterest
struct PinterestInputView: View {
    @Binding var pinterestURL: String
    @Binding var pinterestTitle: String
    @Binding var isPresented: Bool
    var onAdd: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isURLFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Añadir imagen de Pinterest")
                .font(.custom("Lato-Regular", size: 14))
                .fontWeight(.medium)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Título")
                    .font(.custom("Lato-Regular", size: 12))
                    .foregroundColor(.gray)
                
                TextField("Título descriptivo", text: $pinterestTitle)
                    .font(.custom("Lato-Regular", size: 14))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("URL de Pinterest")
                    .font(.custom("Lato-Regular", size: 12))
                    .foregroundColor(.gray)
                
                TextField("https://www.pinterest.com/...", text: $pinterestURL)
                    .font(.custom("Lato-Regular", size: 14))
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                    .cornerRadius(4)
                    .focused($isURLFocused)
            }
            
            HStack {
                Spacer()
                
                Button("Cancelar") {
                    isPresented = false
                }
                .font(.custom("Lato-Regular", size: 14))
                .foregroundColor(.gray)
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 12)
                
                Button("Añadir") {
                    onAdd()
                }
                .font(.custom("Lato-Regular", size: 14))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 12)
                .disabled(pinterestURL.isEmpty || pinterestTitle.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 300)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onAppear {
            isURLFocused = true
        }
    }
}

struct FreeWriteContentView_Previews: PreviewProvider {
    static var previews: some View {
        FreeWriteContentView(selectedMode: .constant(.writing))
    }
}
