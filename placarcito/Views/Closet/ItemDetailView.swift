//
//  ItemDetailView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var item: ClothingItem
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Photo Presentation Container
                ZStack(alignment: .bottomTrailing) {
                    Rectangle()
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .aspectRatio(1.1, contentMode: .fit)
                        .cornerRadius(24)
                    
                    if let data = item.photoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .padding(20)
                    } else {
                        Image(systemName: item.category.iconName)
                            .font(.system(size: 80, weight: .thin))
                            .foregroundColor(.secondary)
                    }
                    
                    // Color chip
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(hex: item.primaryColorHex))
                            .frame(width: 14, height: 14)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                        Text(item.colorName)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(14)
                    .padding(16)
                }
                .padding(.horizontal, 20)
                
                // Key Action Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button {
                            item.wearCount += 1
                            try? modelContext.save()
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Registrar Uso Hoy")
                            }
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        
                        Menu {
                            ForEach(LaundryStatus.allCases) { status in
                                Button {
                                    item.laundryStatus = status
                                    try? modelContext.save()
                                } label: {
                                    Label(status.rawValue, systemImage: status.icon)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: item.laundryStatus.icon)
                                Text(item.laundryStatus.rawValue)
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .foregroundColor(.primary)
                            .cornerRadius(14)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Metrics / Cost-Per-Wear Cards
                HStack(spacing: 12) {
                    MetricCard(title: "USOS TOTALES", value: "\(item.wearCount)", subtitle: "Veces vestida")
                    MetricCard(
                        title: "COSTO / USO",
                        value: item.wearCount > 0 ? "$\(String(format: "%.2f", item.costPerWear))" : "N/A",
                        subtitle: "Precio: $\(Int(item.purchasePrice))"
                    )
                }
                .padding(.horizontal, 20)
                
                // Specifications Table
                VStack(alignment: .leading, spacing: 16) {
                    Text("ESPECIFICACIONES")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.secondary)
                        .tracking(1.5)
                    
                    VStack(spacing: 0) {
                        SpecRow(title: "Categoría", value: item.category.rawValue)
                        Divider()
                        SpecRow(title: "Estilo / Prenda", value: item.subCategory.isEmpty ? "-" : item.subCategory)
                        Divider()
                        SpecRow(title: "Estación / Clima", value: item.season.rawValue)
                        Divider()
                        SpecRow(title: "Ocasión", value: item.occasion.rawValue)
                        Divider()
                        SpecRow(title: "Estado de Limpieza", value: item.laundryStatus.rawValue)
                    }
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                
                // Delete button
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Text("Eliminar Prenda")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.red)
                }
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("¿Eliminar prenda?", isPresented: $showingDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                modelContext.delete(item)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Esta acción eliminará la prenda de tu armario y de los outfits guardados.")
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.secondary)
                .tracking(1)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct SpecRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
