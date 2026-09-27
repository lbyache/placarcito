//
//  ClosetAnalyticsView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct ClosetAnalyticsView: View {
    @Query private var items: [ClothingItem]
    @Query private var outfits: [Outfit]
    
    var totalValuation: Double {
        items.reduce(0) { $0 + $1.purchasePrice }
    }
    
    var totalWears: Int {
        items.reduce(0) { $0 + $1.wearCount }
    }
    
    var averageCostPerWear: Double {
        let itemsWithWears = items.filter { $0.wearCount > 0 }
        guard !itemsWithWears.isEmpty else { return 0 }
        let totalCostPerWear = itemsWithWears.reduce(0.0) { $0 + $1.costPerWear }
        return totalCostPerWear / Double(itemsWithWears.count)
    }
    
    var topWornItems: [ClothingItem] {
        Array(items.sorted(by: { $0.wearCount > $1.wearCount }).prefix(3))
    }
    
    var leastWornItems: [ClothingItem] {
        Array(items.sorted(by: { $0.wearCount < $1.wearCount }).prefix(3))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ESTADÍSTICAS DEL PLACARD")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(2)
                        
                        Text("Análisis & Métricas")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // High Level Summary Cards
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            AnalyticsTile(
                                title: "PRENDAS TOTALES",
                                value: "\(items.count)",
                                subtitle: "\(items.filter { $0.laundryStatus == .clean }.count) listas para usar",
                                iconName: "tshirt"
                            )
                            
                            AnalyticsTile(
                                title: "VALOR ESTIMADO",
                                value: "$\(Int(totalValuation))",
                                subtitle: "En tu ropero",
                                iconName: "dollarsign.circle"
                            )
                        }
                        
                        HStack(spacing: 12) {
                            AnalyticsTile(
                                title: "COSTO PROMEDIO / USO",
                                value: "$\(String(format: "%.2f", averageCostPerWear))",
                                subtitle: "Eficiencia de ropero",
                                iconName: "chart.bar"
                            )
                            
                            AnalyticsTile(
                                title: "USOS REGISTRADOS",
                                value: "\(totalWears)",
                                subtitle: "\(outfits.count) outfits creados",
                                iconName: "flame"
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Top Worn Items Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("PRENDAS MÁS USADAS")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(1.5)
                        
                        VStack(spacing: 10) {
                            ForEach(topWornItems) { item in
                                RankingRow(item: item, highlightColor: .black)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Least Worn / Underused Items Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("PRENDAS MENOS UTILIZADAS")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(1.5)
                        
                        VStack(spacing: 10) {
                            ForEach(leastWornItems) { item in
                                RankingRow(item: item, highlightColor: .gray)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Category Breakdown
                    VStack(alignment: .leading, spacing: 14) {
                        Text("DISTRIBUCIÓN POR CATEGORÍA")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundColor(.secondary)
                            .tracking(1.5)
                        
                        VStack(spacing: 10) {
                            ForEach(ClothingCategory.allCases) { cat in
                                let count = items.filter { $0.category == cat }.count
                                let percentage = items.isEmpty ? 0 : (Double(count) / Double(items.count))
                                CategoryProgressBar(categoryName: cat.rawValue, count: count, percentage: percentage)
                            }
                        }
                        .padding(16)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AnalyticsTile: View {
    let title: String
    let value: String
    let subtitle: String
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: iconName)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct RankingRow: View {
    let item: ClothingItem
    let highlightColor: Color
    
    var body: some View {
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
                Text(item.colorName)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(item.wearCount) usos")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundColor(highlightColor)
                
                if item.purchasePrice > 0 {
                    Text("$\(String(format: "%.2f", item.costPerWear))/uso")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(14)
    }
}

struct CategoryProgressBar: View {
    let categoryName: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(categoryName)
                    .font(.system(size: 12, weight: .medium))
                Spacer()
                Text("\(count) prendas (\(Int(percentage * 100))%)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(Color.black)
                        .frame(width: geo.size.width * CGFloat(percentage), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}
