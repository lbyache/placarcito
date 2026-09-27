//
//  AssistantChatView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct AssistantChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ClothingItem]
    
    @State private var assistantService = AIAssistantService()
    @State private var weatherService = WeatherService()
    
    @State private var inputText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Scandinavian Header & Weather Widget
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PERSONAL STYLIST")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                                .tracking(2)
                            
                            Text("Asistente de IA")
                                .font(.system(size: 28, weight: .bold))
                        }
                        Spacer()
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .padding(10)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(Circle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Weather Card Bar
                    WeatherOutfitCardView(weather: weatherService.currentWeather) {
                        assistantService.sendMessage("¿Qué outfit me recomiendas para el clima actual de \(weatherService.currentWeather.temperatureC)°C?", availableItems: items, currentTemp: weatherService.currentWeather.temperatureC)
                    }
                    .padding(.horizontal, 20)
                }
                .background(Color(uiColor: .systemBackground))
                
                Divider()
                    .padding(.top, 8)
                
                // Chat Message Stream
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(assistantService.messages) { msg in
                                ChatMessageBubble(message: msg, availableItems: items)
                                    .id(msg.id)
                            }
                            
                            if assistantService.isGenerating {
                                HStack {
                                    ProgressView()
                                        .tint(.black)
                                    Text("Placarcito está pensando...")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                                .padding(12)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .onChange(of: assistantService.messages.count) { _, _ in
                        if let last = assistantService.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Quick Prompt Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        QuickPromptChip(text: "💼 Outfit para oficina") {
                            sendQuickPrompt("Recomiéndame un outfit formal de trabajo con mis prendas limpias.")
                        }
                        QuickPromptChip(text: "🌤️ Clima 18°C") {
                            sendQuickPrompt("¿Qué me pongo hoy si hace 18°C y está templado?")
                        }
                        QuickPromptChip(text: "🌙 Salida de noche") {
                            sendQuickPrompt("Propón un look elegante sport para salir de noche.")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }
                .background(Color(uiColor: .secondarySystemBackground))
                
                // Input Bar
                HStack(spacing: 10) {
                    TextField("Pregunta sobre tu estilo o combina tu ropero...", text: $inputText)
                        .font(.system(size: 14))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(20)
                    
                    Button {
                        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        let text = inputText
                        inputText = ""
                        assistantService.sendMessage(text, availableItems: items, currentTemp: weatherService.currentWeather.temperatureC)
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .black)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(uiColor: .systemBackground))
            }
            .navigationBarHidden(true)
        }
    }
    
    private func sendQuickPrompt(_ prompt: String) {
        assistantService.sendMessage(prompt, availableItems: items, currentTemp: weatherService.currentWeather.temperatureC)
    }
}

struct QuickPromptChip: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(uiColor: .systemBackground))
                .foregroundColor(.primary)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct ChatMessageBubble: View {
    let message: ChatMessage
    let availableItems: [ClothingItem]
    
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 10) {
                Text(message.text)
                    .font(.system(size: 14))
                    .lineSpacing(4)
                    .padding(14)
                    .background(message.sender == .user ? Color.black : Color(uiColor: .secondarySystemBackground))
                    .foregroundColor(message.sender == .user ? .white : .primary)
                    .cornerRadius(18)
                
                // If message has suggested items
                if let itemIds = message.suggestedItemIds {
                    let matchingItems = availableItems.filter { itemIds.contains($0.id) }
                    if !matchingItems.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(message.suggestedOutfitName ?? "Outfit Recomendado")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                ForEach(matchingItems) { item in
                                    VStack(spacing: 4) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(uiColor: .tertiarySystemBackground))
                                                .frame(width: 44, height: 44)
                                            if let data = item.photoData, let img = UIImage(data: data) {
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 34, height: 34)
                                            } else {
                                                Image(systemName: item.category.iconName)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Text(item.name)
                                            .font(.system(size: 9, weight: .medium))
                                            .lineLimit(1)
                                            .frame(width: 50)
                                    }
                                }
                            }
                        }
                        .padding(12)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(14)
                    }
                }
            }
            .frame(maxWidth: 280, alignment: message.sender == .user ? .trailing : .leading)
            
            if message.sender == .assistant { Spacer() }
        }
        .padding(.horizontal, 20)
    }
}

struct WeatherOutfitCardView: View {
    let weather: WeatherInfo
    let onAskRecommendation: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: weather.iconName)
                        .foregroundColor(.orange)
                    Text("\(weather.city) • \(weather.temperatureC)°C")
                        .font(.system(size: 14, weight: .bold))
                }
                Text(weather.condition)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onAskRecommendation) {
                Text("Outfit sugerido")
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}
