//
//  LaundryTrackerView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct LaundryTrackerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ClothingItem.createdAt, order: .reverse) private var items: [ClothingItem]
    @Query(sort: \LoggedOutfit.date, order: .reverse) private var loggedOutfits: [LoggedOutfit]
    
    @State private var selectedTab: Int = 0 // 0 = Laundry, 1 = Calendar
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ORGANIZACIÓN Y ROTACIÓN")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(2)
                        
                        Text("Lavadero & Agenda")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Segment Picker
                    Picker("Sección", selection: $selectedTab) {
                        Text("Estado de Lavado").tag(0)
                        Text("Historial Diario").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .background(Color(uiColor: .systemBackground))
                
                Divider()
                
                if selectedTab == 0 {
                    LaundryStatusSection(items: items)
                } else {
                    LookbookCalendarSection(logs: loggedOutfits)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LaundryStatusSection: View {
    @Environment(\.modelContext) private var modelContext
    let items: [ClothingItem]
    
    var cleanItems: [ClothingItem] { items.filter { $0.laundryStatus == .clean } }
    var dirtyItems: [ClothingItem] { items.filter { $0.laundryStatus == .dirty } }
    var inLaundryItems: [ClothingItem] { items.filter { $0.laundryStatus == .inLaundry } }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Quick Batch Reset Action
                if !dirtyItems.isEmpty || !inLaundryItems.isEmpty {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Ropa pendiente de lavado")
                                .font(.system(size: 14, weight: .bold))
                            Text("\(dirtyItems.count + inLaundryItems.count) prendas fuera de servicio")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Button {
                            markAllAsClean()
                        } label: {
                            Text("Marcar Todo Limpio")
                                .font(.system(size: 12, weight: .bold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(16)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                
                // Group 1: Dirty (Para Lavar)
                LaundryGroupCard(
                    title: "PARA LAVAR",
                    status: .dirty,
                    items: dirtyItems,
                    nextActionTitle: "Enviar a Lavadero",
                    onNextAction: { item in
                        item.laundryStatus = .inLaundry
                        try? modelContext.save()
                    }
                )
                
                // Group 2: In Laundry (En Lavadero)
                LaundryGroupCard(
                    title: "EN LAVADERO",
                    status: .inLaundry,
                    items: inLaundryItems,
                    nextActionTitle: "Marcar Limpio",
                    onNextAction: { item in
                        item.laundryStatus = .clean
                        try? modelContext.save()
                    }
                )
                
                // Group 3: Clean (Listas)
                LaundryGroupCard(
                    title: "LISTAS PARA USAR",
                    status: .clean,
                    items: cleanItems,
                    nextActionTitle: "Usar / Ensuciar",
                    onNextAction: { item in
                        item.laundryStatus = .dirty
                        try? modelContext.save()
                    }
                )
            }
            .padding(.vertical, 16)
        }
    }
    
    private func markAllAsClean() {
        for item in items {
            item.laundryStatus = .clean
        }
        try? modelContext.save()
    }
}

struct LaundryGroupCard: View {
    let title: String
    let status: LaundryStatus
    let items: [ClothingItem]
    let nextActionTitle: String
    let onNextAction: (ClothingItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: status.icon)
                    .foregroundColor(Color(hex: status.colorHex))
                Text(title)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                    .tracking(1.5)
                Spacer()
                Text("\(items.count) prendas")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            if items.isEmpty {
                Text("No hay prendas en este estado")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 8) {
                    ForEach(items) { item in
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(uiColor: .tertiarySystemBackground))
                                    .frame(width: 44, height: 44)
                                if let data = item.photoData, let img = UIImage(data: data) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 34, height: 34)
                                } else {
                                    Image(systemName: item.category.iconName)
                                        .font(.system(size: 18))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.name)
                                    .font(.system(size: 13, weight: .semibold))
                                Text("\(item.colorName) • \(item.category.rawValue)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button {
                                onNextAction(item)
                            } label: {
                                Text(nextActionTitle)
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(10)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(14)
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct LookbookCalendarSection: View {
    let logs: [LoggedOutfit]
    
    var body: some View {
        if logs.isEmpty {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "calendar")
                    .font(.system(size: 44, weight: .light))
                    .foregroundColor(.gray)
                Text("Historial de Outfits Vacío")
                    .font(.system(size: 16, weight: .medium))
                Text("Cuando vistas o registres tus combinaciones diarias, aparecerán registradas aquí.")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
            }
        } else {
            List(logs) { log in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(log.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    if let outfit = log.outfit {
                        Text(outfit.name)
                            .font(.system(size: 15, weight: .bold))
                    }
                    
                    if !log.notes.isEmpty {
                        Text(log.notes)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(log.allItems) { item in
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(Color(hex: item.primaryColorHex))
                                        .frame(width: 8, height: 8)
                                    Text(item.name)
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.vertical, 6)
                .listRowSeparator(.visible)
            }
            .listStyle(PlainListStyle())
        }
    }
}
