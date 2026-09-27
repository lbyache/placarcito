//
//  ContentView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: Tab = .closet
    
    enum Tab {
        case closet
        case generator
        case assistant
        case laundry
        case analytics
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ClosetView()
                .tabItem {
                    Label("Armario", systemImage: "square.grid.2x2.fill")
                }
                .tag(Tab.closet)
            
            OutfitGeneratorView()
                .tabItem {
                    Label("Outfits", systemImage: "sparkles")
                }
                .tag(Tab.generator)
            
            AssistantChatView()
                .tabItem {
                    Label("Asistente", systemImage: "message.fill")
                }
                .tag(Tab.assistant)
            
            LaundryTrackerView()
                .tabItem {
                    Label("Lavadero", systemImage: "washer.fill")
                }
                .tag(Tab.laundry)
            
            ClosetAnalyticsView()
                .tabItem {
                    Label("Métricas", systemImage: "chart.bar.fill")
                }
                .tag(Tab.analytics)
        }
        .tint(.black)
        .onAppear {
            SeedData.populateIfNeeded(modelContext: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ClothingItem.self, Outfit.self, LoggedOutfit.self], inMemory: true)
}
