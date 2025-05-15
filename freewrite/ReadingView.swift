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
    
    // Estado para el documento actual
    @State private var currentDocument = EnrichedDocument.sample()
    
    // Estado para el panel lateral
    @State private var showSensoryPanel = false
    @State private var selectedElement: SensoryElement? = nil
    
    // Estado para el modo de lectura
    @State private var isPaginatedMode = false
    
    // Controlador para el texto y posiciones
    @State private var scrollTarget: Int? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            // Panel principal de lectura
            VStack(spacing: 0) {
                // Barra superior con título y controles
                HStack {
                    // Botón de regreso
                    Button(action: {
                        selectedMode = nil
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 14))
                            Text("Inicio")
                                .font(.custom("Lato-Regular", size: 14))
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Text(currentDocument.title)
                        .font(.custom("Lato-Regular", size: 18))
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    // Botón para alternar modo de paginación
                    Button(action: {
                        isPaginatedMode.toggle()
                    }) {
                        Image(systemName: isPaginatedMode ? "arrow.down" : "book")
                            .font(.system(size: 16))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(8)
                            .background(colorScheme == .dark ? Color.black : Color.white)
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help(isPaginatedMode ? "Cambiar a desplazamiento" : "Cambiar a páginas")
                }
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                
                // Contenido del texto con marcadores sensoriales
                ScrollView(isPaginatedMode ? [] : .vertical, showsIndicators: !isPaginatedMode) {
                    VStack(alignment: .leading, spacing: 16) {
                        // Vista de texto enriquecido
                        EnrichedTextView(text: currentDocument.content, elements: currentDocument.sensoryElements, onElementTapped: { element in
                            selectedElement = element
                            showSensoryPanel = true
                        })
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorScheme == .dark ? Color.black : Color.white)
            }
            
            // Panel lateral para elementos sensoriales
            if showSensoryPanel, let element = selectedElement {
                VStack(spacing: 0) {
                    // Cabecera del panel
                    HStack {
                        // Icono según tipo
                        Image(systemName: element.type == .spotify ? "music.note" : "photo")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .gray : .gray)
                            .padding(.trailing, 4)
                            
                        Text(element.title)
                            .font(.custom("Lato-Regular", size: 14))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button(action: {
                            showSensoryPanel = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 10))
                                .foregroundColor(colorScheme == .dark ? .gray : .gray)
                                .padding(6)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    Divider()
                        .background(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2))
                    
                    // Contenido del panel
                    if let url = URL(string: element.url) {
                        WebView(url: url)
                            .frame(maxHeight: .infinity)
                    } else {
                        Text("URL inválida")
                            .font(.custom("Lato-Regular", size: 14))
                            .foregroundColor(.gray)
                            .frame(maxHeight: .infinity)
                    }
                }
                .frame(width: 320)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .animation(.easeInOut(duration: 0.2), value: showSensoryPanel)
            }
        }
    }
}

// Vista para mostrar texto enriquecido con marcadores de elementos sensoriales
struct EnrichedTextView: View {
    var text: String
    var elements: [SensoryElement]
    var onElementTapped: (SensoryElement) -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Indicadores laterales
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(elements) { element in
                    if let position = calculateYPosition(for: element) {
                        Button(action: {
                            onElementTapped(element)
                        }) {
                            if element.type == .spotify {
                                Image(systemName: "music.note")
                                    .font(.system(size: 12))
                                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 12))
                                    .foregroundColor(colorScheme == .dark ? .gray : .gray)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.top, position - 6) // Ajuste para centrar
                        .padding(.horizontal, 5) // Añadir padding horizontal para mayor área de toque
                        .padding(.vertical, 5) // Añadir padding vertical para mayor área de toque
                        .contentShape(Rectangle())
                    }
                }
                Spacer()
            }
            .frame(width: 20)
            .padding(.leading, 15)
            
            // Texto principal
            Text(text)
                .font(.custom("Lato-Regular", size: 18))
                .lineSpacing(8)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 50) // Añadir espacio a la derecha para equilibrar
        }
    }
    
    // Método simple para calcular posición vertical (aproximada) de un elemento sensorial
    private func calculateYPosition(for element: SensoryElement) -> CGFloat? {
        // Cálculo simplificado - en una implementación real, habría que tener en cuenta saltos de línea
        let linesBeforeElement = text.prefix(element.position).filter { $0 == "\n" }.count
        let charsPerLine = 80.0 // Aproximación
        let linesFromChars = Double(element.position) / charsPerLine
        
        let totalLines = Double(linesBeforeElement) + linesFromChars
        return totalLines * 26 // 18pt de fuente + 8pt de espaciado
    }
}

// Vista previa para ReadingView
struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView(selectedMode: .constant(.reading))
    }
}
