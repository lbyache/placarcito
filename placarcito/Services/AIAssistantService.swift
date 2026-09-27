//
//  AIAssistantService.swift
//  placarcito
//

import Foundation
import SwiftUI
import Observation

@Observable
public final class AIAssistantService {
    public var messages: [ChatMessage] = []
    public var isGenerating: Bool = false
    
    public init() {
        // Initial welcome message from the personal assistant
        let welcome = ChatMessage(
            sender: .assistant,
            text: "¡Hola! Soy Placarcito, tu asistente personal de estilo escandinavo. 🌿\n\nPuedes preguntarme qué ponerte para un evento, cómo combinar prendas de tu ropero o pedirme sugerencias según el clima."
        )
        self.messages.append(welcome)
    }
    
    public func sendMessage(_ text: String, availableItems: [ClothingItem], currentTemp: Int = 19) {
        let userMsg = ChatMessage(sender: .user, text: text)
        messages.append(userMsg)
        
        isGenerating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.isGenerating = false
            
            let response = self.generateSmartResponse(query: text, items: availableItems, temp: currentTemp)
            self.messages.append(response)
        }
    }
    
    private func generateSmartResponse(query: String, items: [ClothingItem], temp: Int) -> ChatMessage {
        let cleanItems = items.filter { $0.laundryStatus == .clean }
        let queryLower = query.lowercased()
        
        if queryLower.contains("oficina") || queryLower.contains("trabajo") || queryLower.contains("formal") {
            let formalOutfit = OutfitEngine.generateOutfit(from: cleanItems, occasion: .work, temperatureC: temp)
            
            return ChatMessage(
                sender: .assistant,
                text: "Para un look de trabajo elegante y sobrio a \(temp)°C, te sugiero combinar:\n\n• \(formalOutfit.map { "\($0.name) (\($0.colorName))" }.joined(separator: "\n• "))\n\nEsta combinación mantiene una línea minimalista y profesional.",
                suggestedItemIds: formalOutfit.map { $0.id },
                suggestedOutfitName: "Look Oficina Nordisk"
            )
        } else if queryLower.contains("noche") || queryLower.contains("salir") || queryLower.contains("fiesta") {
            let nightOutfit = OutfitEngine.generateOutfit(from: cleanItems, occasion: .smartCasual, temperatureC: temp)
            return ChatMessage(
                sender: .assistant,
                text: "Para salir de noche a \(temp)°C, la clave es el contraste inteligente:\n\n• \(nightOutfit.map { "\($0.name) [\($0.colorName)]" }.joined(separator: "\n• "))\n\nTip de estilo: Mantén los accesorios discretos para resaltar el corte de las prendas.",
                suggestedItemIds: nightOutfit.map { $0.id },
                suggestedOutfitName: "Look Noche Noir"
            )
        } else if queryLower.contains("frio") || queryLower.contains("frío") || queryLower.contains("invierno") || temp < 15 {
            let suggestedOutfit = OutfitEngine.generateOutfit(from: cleanItems, occasion: .casual, temperatureC: 12)
            
            return ChatMessage(
                sender: .assistant,
                text: "Para mantener la calidez sin perder elegancia escandinava a baja temperatura, te recomiendo este look superpuesto (layering):\n\n• \(suggestedOutfit.map { "\($0.name)" }.joined(separator: "\n• "))\n\nRecuerda abrochar el abrigo solo hasta la mitad para dar soltura visual.",
                suggestedItemIds: suggestedOutfit.map { $0.id },
                suggestedOutfitName: "Layering Nórdico"
            )
        } else {
            // General query
            let casualOutfit = OutfitEngine.generateOutfit(from: cleanItems, occasion: .casual, temperatureC: temp)
            return ChatMessage(
                sender: .assistant,
                text: "Analicé las prendas disponibles en tu ropero y para la temperatura actual de \(temp)°C te propongo esta combinación equilibada:\n\n• \(casualOutfit.map { "\($0.name) (\($0.colorName))" }.joined(separator: "\n• "))\n\n¿Quieres que guardemos este outfit en tu Lookbook o prefieres probar otra alternativa?",
                suggestedItemIds: casualOutfit.map { $0.id },
                suggestedOutfitName: "Casual Scandinavian"
            )
        }
    }
}
