//
//  OutfitGeneratorView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct OutfitGeneratorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ClothingItem]
    @Query(sort: \Outfit.createdAt, order: .reverse) private var savedOutfits: [Outfit]
    
    @State private var selectedOccasion: ClothingOccasion = .casual
    @State private var temperatureC: Double = 19.0
    @State private var generatedItems: [ClothingItem] = []
    @State private var lockedItemIds: Set<UUID> = []
    @State private var showingSavedToast: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GENERADOR DE OUTFITS")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(2)
                        
                        Text("Combinador Inteligente")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Controls Card
                    VStack(spacing: 16) {
                        // Temperature control
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "thermometer.medium")
                                    .foregroundColor(.gray)
                                Text("Temperatura Estimada:")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(Int(temperatureC))°C")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                            }
                            
                            Slider(value: $temperatureC, in: 5...35, step: 1)
                                .tint(.black)
                        }
                        
                        Divider()
                        
                        // Occasion control
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ocasión del Día")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(ClothingOccasion.allCases) { occ in
                                        FilterChip(title: occ.rawValue, isSelected: selectedOccasion == occ) {
                                            selectedOccasion = occ
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    
                    // Generate Action Button
                    Button {
                        generateNewOutfit()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                            Text("Generar Outfit Inteligente")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    
                    // Generated Outfit Grid / Display
                    if generatedItems.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 44, weight: .ultraLight))
                                .foregroundColor(.gray)
                            Text("Toca el botón para crear una combinación")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .frame(height: 220)
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("PROPUESTA DE COMBINACIÓN")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .tracking(1.5)
                                Spacer()
                                Text("\(generatedItems.count) prendas")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(generatedItems) { item in
                                    GeneratedItemRow(
                                        item: item,
                                        isLocked: lockedItemIds.contains(item.id),
                                        onToggleLock: {
                                            if lockedItemIds.contains(item.id) {
                                                lockedItemIds.remove(item.id)
                                            } else {
                                                lockedItemIds.insert(item.id)
                                            }
                                        }
                                    )
                                }
                            }
                            
                            // Save & Log Action Buttons
                            HStack(spacing: 12) {
                                Button {
                                    saveOutfitToLookbook()
                                } label: {
                                    HStack {
                                        Image(systemName: "bookmark.fill")
                                        Text("Guardar Outfit")
                                    }
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.black)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                }
                                
                                Button {
                                    logOutfitToday()
                                } label: {
                                    HStack {
                                        Image(systemName: "figure.walk")
                                        Text("Vestir Hoy")
                                    }
                                    .font(.system(size: 13, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Saved Lookbook Section
                    if !savedOutfits.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("TU LOOKBOOK GUARDADO")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(savedOutfits) { outfit in
                                        SavedOutfitCard(outfit: outfit)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
                .padding(.bottom, 40)
            }
            .onAppear {
                if generatedItems.isEmpty && !items.isEmpty {
                    generateNewOutfit()
                }
            }
            .overlay(
                VStack {
                    if showingSavedToast {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Outfit guardado con éxito")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    Spacer()
                }
                .animation(.easeInOut, value: showingSavedToast)
            )
        }
    }
    
    private func generateNewOutfit() {
        let freshOutfit = OutfitEngine.generateOutfit(
            from: items,
            occasion: selectedOccasion,
            temperatureC: Int(temperatureC),
            onlyClean: true
        )
        
        // Keep locked items
        var finalCombo: [ClothingItem] = []
        for oldItem in generatedItems where lockedItemIds.contains(oldItem.id) {
            finalCombo.append(oldItem)
        }
        
        for newItem in freshOutfit {
            if !finalCombo.contains(where: { $0.category == newItem.category }) {
                finalCombo.append(newItem)
            }
        }
        
        self.generatedItems = finalCombo
    }
    
    private func saveOutfitToLookbook() {
        guard !generatedItems.isEmpty else { return }
        let newOutfit = Outfit(
            name: "\(selectedOccasion.rawValue) \(Int(temperatureC))°C",
            occasion: selectedOccasion,
            minTemp: Int(temperatureC) - 4,
            maxTemp: Int(temperatureC) + 4,
            isFavorite: true,
            items: generatedItems
        )
        modelContext.insert(newOutfit)
        try? modelContext.save()
        
        showingSavedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showingSavedToast = false
        }
    }
    
    private func logOutfitToday() {
        for item in generatedItems {
            item.wearCount += 1
        }
        let logged = LoggedOutfit(date: Date(), notes: "Outfit generado para \(selectedOccasion.rawValue)", customItems: generatedItems)
        modelContext.insert(logged)
        try? modelContext.save()
        
        showingSavedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showingSavedToast = false
        }
    }
}

struct GeneratedItemRow: View {
    let item: ClothingItem
    let isLocked: Bool
    let onToggleLock: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            // Photo thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .frame(width: 54, height: 54)
                
                if let data = item.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                } else {
                    Image(systemName: item.category.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.category.rawValue.uppercased())
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                
                Text(item.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                
                Text(item.colorName)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onToggleLock) {
                Image(systemName: isLocked ? "lock.fill" : "lock.open")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(8)
                    .background(isLocked ? Color.black : Color(uiColor: .secondarySystemBackground))
                    .foregroundColor(isLocked ? .white : .secondary)
                    .clipShape(Circle())
            }
        }
        .padding(10)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.12), lineWidth: 1)
        )
    }
}

struct SavedOutfitCard: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(outfit.name)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Spacer()
                Image(systemName: outfit.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
            
            HStack(spacing: -8) {
                ForEach(outfit.items.prefix(4)) { item in
                    ZStack {
                        Circle()
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                        
                        if let data = item.photoData, let img = UIImage(data: data) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        } else {
                            Image(systemName: item.category.iconName)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            Text("\(outfit.items.count) prendas • \(outfit.occasion.rawValue)")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .frame(width: 170)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}
