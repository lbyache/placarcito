//
//  AddEditItemView.swift
//  placarcito
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddEditItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var category: ClothingCategory = .upper
    @State private var subCategory: String = ""
    @State private var primaryColorHex: String = "#18181B"
    @State private var colorName: String = "Negro"
    @State private var season: ClothingSeason = .allYear
    @State private var occasion: ClothingOccasion = .casual
    @State private var purchasePriceText: String = ""
    
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isProcessingImage: Bool = false
    @State private var showingCameraSheet: Bool = false
    
    let colorPresetOptions: [(name: String, hex: String)] = [
        ("Negro", "#18181B"),
        ("Blanco", "#FFFFFF"),
        ("Gris Charcoal", "#3F3F46"),
        ("Gris Claro", "#A1A1AA"),
        ("Azul Marino", "#1E293B"),
        ("Azul Celeste", "#BAE6FD"),
        ("Beige Arena", "#E4E4E7"),
        ("Marrón Cacao", "#451A03"),
        ("Verde Oliva", "#365314"),
        ("Rojo Carmín", "#991B1B")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Title
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CATÁLOGO DE PRENDAS")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(2.5)
                        
                        Text("Registrar Prenda")
                            .font(.system(size: 26, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Photo Capture Container
                    VStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                                .frame(height: 240)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                )
                            
                            if let img = selectedImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 220)
                                    .padding(12)
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 40, weight: .thin))
                                        .foregroundColor(.secondary)
                                    Text("Captura o sube la fotografía de tu prenda")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            if isProcessingImage {
                                ZStack {
                                    Color.black.opacity(0.65)
                                        .cornerRadius(20)
                                    VStack(spacing: 10) {
                                        ProgressView()
                                            .tint(.white)
                                        Text("Removiendo fondo con Vision AI...")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Dual Photo Buttons: Camera & Gallery
                        HStack(spacing: 12) {
                            Button {
                                showingCameraSheet = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "camera.fill")
                                    Text("Tomar Foto")
                                }
                                .font(.system(size: 13, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                            }
                            
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                HStack(spacing: 6) {
                                    Image(systemName: "photo.on.rectangle")
                                    Text("Galería")
                                }
                                .font(.system(size: 13, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                                )
                            }
                            
                            if selectedImage != nil {
                                Button {
                                    processBackgroundRemoval()
                                } label: {
                                    Image(systemName: "scissors")
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(12)
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .foregroundColor(.primary)
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Form Content Cards
                    VStack(spacing: 20) {
                        // Section 1: Basic Info
                        VStack(alignment: .leading, spacing: 14) {
                            Text("INFORMACIÓN PRINCIPAL")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            VStack(spacing: 12) {
                                CustomTextField(title: "Nombre de prenda", placeholder: "ej. Remera Oversize Noir", text: $name)
                                CustomTextField(title: "Subcategoría / Modelo", placeholder: "ej. Camisa Oxford Slim", text: $subCategory)
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(20)
                        
                        // Section 2: Category & Color
                        VStack(alignment: .leading, spacing: 14) {
                            Text("CATEGORÍA Y COLOR")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            // Category Selector Chips
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Categoría Principal")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(ClothingCategory.allCases) { cat in
                                            FilterChip(title: cat.rawValue, isSelected: category == cat) {
                                                category = cat
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Color Selector Swatches
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Color Predominante (\(colorName))")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(colorPresetOptions, id: \.hex) { preset in
                                            Button {
                                                primaryColorHex = preset.hex
                                                colorName = preset.name
                                            } label: {
                                                VStack(spacing: 4) {
                                                    Circle()
                                                        .fill(Color(hex: preset.hex))
                                                        .frame(width: 32, height: 32)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(primaryColorHex == preset.hex ? Color.black : Color.gray.opacity(0.3), lineWidth: primaryColorHex == preset.hex ? 3 : 1)
                                                        )
                                                    Text(preset.name)
                                                        .font(.system(size: 9, weight: primaryColorHex == preset.hex ? .bold : .regular))
                                                        .foregroundColor(.primary)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(20)
                        
                        // Section 3: Season & Occasion
                        VStack(alignment: .leading, spacing: 14) {
                            Text("CLASIFICACIÓN Y VALOR")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Estación / Clima")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(ClothingSeason.allCases) { s in
                                            FilterChip(title: s.rawValue, isSelected: season == s) {
                                                season = s
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ocasión Recomendada")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(ClothingOccasion.allCases) { o in
                                            FilterChip(title: o.rawValue, isSelected: occasion == o) {
                                                occasion = o
                                            }
                                        }
                                    }
                                }
                            }
                            
                            CustomTextField(title: "Precio de Compra ($ USD)", placeholder: "0.00", text: $purchasePriceText, keyboardType: .decimalPad)
                        }
                        .padding(16)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(20)
                        
                        // Action Guardar
                        Button {
                            saveItem()
                        } label: {
                            Text("Guardar Prenda en Armario")
                                .font(.system(size: 15, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCameraSheet) {
                CameraPicker { image in
                    self.selectedImage = image
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            self.selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
    
    private func processBackgroundRemoval() {
        guard let img = selectedImage else { return }
        isProcessingImage = true
        VisionService.removeBackground(from: img) { processed in
            self.isProcessingImage = false
            if let processed = processed {
                self.selectedImage = processed
            }
        }
    }
    
    private func saveItem() {
        let price = Double(purchasePriceText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let photoData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        let newItem = ClothingItem(
            name: name,
            category: category,
            subCategory: subCategory,
            primaryColorHex: primaryColorHex,
            colorName: colorName,
            season: season,
            occasion: occasion,
            laundryStatus: .clean,
            wearCount: 0,
            purchasePrice: price,
            photoData: photoData
        )
        
        modelContext.insert(newItem)
        try? modelContext.save()
        dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
        }
    }
}
