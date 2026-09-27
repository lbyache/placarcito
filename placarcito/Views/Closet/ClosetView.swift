//
//  ClosetView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct ClosetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ClothingItem.createdAt, order: .reverse) private var items: [ClothingItem]
    
    @State private var selectedCategory: ClothingCategory? = nil
    @State private var selectedOccasion: ClothingOccasion? = nil
    @State private var selectedLaundryStatus: LaundryStatus? = nil
    @State private var searchText: String = ""
    @State private var showingAddItemSheet = false
    @State private var itemToEdit: ClothingItem? = nil
    
    var filteredItems: [ClothingItem] {
        items.filter { item in
            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            let matchesOccasion = selectedOccasion == nil || item.occasion == selectedOccasion
            let matchesLaundry = selectedLaundryStatus == nil || item.laundryStatus == selectedLaundryStatus
            let matchesSearch = searchText.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.colorName.localizedCaseInsensitiveContains(searchText) ||
                item.subCategory.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesOccasion && matchesLaundry && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Scandinavian Top Header / Search
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PLACARCITO")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.secondary)
                                .tracking(2.5)
                            
                            Text("Mi Armario")
                                .font(.system(size: 30, weight: .bold))
                        }
                        Spacer()
                        
                        Button {
                            showingAddItemSheet = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .bold))
                                Text("Añadir Prenda")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .cornerRadius(24)
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    // Search Bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                        
                        TextField("Buscar prendas, colores, abrigos...", text: $searchText)
                            .font(.system(size: 14))
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Category Filter Scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(title: "Todos (\(items.count))", isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            
                            ForEach(ClothingCategory.allCases) { cat in
                                let count = items.filter { $0.category == cat }.count
                                FilterChip(title: "\(cat.rawValue) (\(count))", isSelected: selectedCategory == cat) {
                                    if selectedCategory == cat {
                                        selectedCategory = nil
                                    } else {
                                        selectedCategory = cat
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 10)
                }
                .background(Color(uiColor: .systemBackground))
                
                Divider()
                
                // Item Grid
                if filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 52, weight: .ultraLight))
                            .foregroundColor(.gray)
                        Text("No hay prendas en el armario")
                            .font(.system(size: 17, weight: .bold))
                        Text("Toca 'Añadir Prenda' para registrar con la cámara de tu teléfono o seleccionar desde la galería.")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button {
                            showingAddItemSheet = true
                        } label: {
                            Text("Añadir Mi Primera Prenda")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .cornerRadius(20)
                        }
                        .padding(.top, 8)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 20) {
                            ForEach(filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(item: item)) {
                                    ClothingCardView(item: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddItemSheet) {
                AddEditItemView()
            }
        }
    }
}

struct ClothingCardView: View {
    let item: ClothingItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                // Image Container
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                        .aspectRatio(1, contentMode: .fit)
                    
                    if let data = item.photoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .padding(14)
                    } else {
                        Image(systemName: item.category.iconName)
                            .font(.system(size: 42, weight: .thin))
                            .foregroundColor(.gray)
                    }
                }
                
                // Status badge with blur
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: item.laundryStatus.colorHex))
                        .frame(width: 6, height: 6)
                    Text(item.laundryStatus.rawValue)
                        .font(.system(size: 9, weight: .bold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: item.primaryColorHex))
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    Text("\(item.colorName) • \(item.category.rawValue)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("\(item.wearCount) usos")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if item.purchasePrice > 0 {
                        Text("$\(Int(item.costPerWear))/uso")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top, 2)
            }
        }
        .padding(10)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}
