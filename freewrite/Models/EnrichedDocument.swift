// Swift 5.0
//
//  EnrichedDocument.swift
//  freewrite (Vibe Reading)
//
//  Created on 5/15/25.
//

import Foundation

// Tipo de elemento sensorial
enum SensoryType: String, Codable {
    case spotify
    case pinterest
}

// Estructura para un elemento sensorial (música o imagen)
struct SensoryElement: Identifiable, Codable {
    var id = UUID()
    var type: SensoryType
    var url: String
    var title: String
    var position: Int  // Posición en el texto (índice de carácter)
}

// Documento enriquecido con elementos sensoriales
struct EnrichedDocument: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var sensoryElements: [SensoryElement]
    
    // Para crear un documento vacío
    static func empty() -> EnrichedDocument {
        return EnrichedDocument(
            id: UUID(),
            title: "Nuevo documento",
            content: "",
            sensoryElements: []
        )
    }
    
    // Para documentos de ejemplo
    static func sample() -> EnrichedDocument {
        return EnrichedDocument(
            id: UUID(),
            title: "La noche estrellada",
            content: "Era una noche estrellada en la ciudad. Las luces brillaban con intensidad mientras caminaba por las calles empedradas. La música flotaba en el aire, evocando recuerdos de tiempos pasados. Una melodía en particular me transportó a aquel verano en París.\n\nDe repente, al doblar la esquina, vi una imagen que me recordó a aquella famosa pintura que tanto admiraba. Los colores intensos y los trazos vibrantes parecían cobrar vida bajo la luz de la luna.",
            sensoryElements: [
                SensoryElement(
                    id: UUID(),
                    type: .spotify,
                    url: "https://open.spotify.com/track/4cOdK2wGLETKBW3PvgPWqT",
                    title: "Música nocturna",
                    position: 150
                ),
                SensoryElement(
                    id: UUID(),
                    type: .pinterest,
                    url: "https://www.pinterest.com/pin/1196337391125946/",
                    title: "La noche estrellada",
                    position: 350
                )
            ]
        )
    }
}

// Gestor de documentos para cargar/guardar
class DocumentManager {
    static let shared = DocumentManager()
    
    func loadSampleDocuments() -> [EnrichedDocument] {
        return [EnrichedDocument.sample()]
    }
}
