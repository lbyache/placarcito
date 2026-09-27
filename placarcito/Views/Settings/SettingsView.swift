//
//  SettingsView.swift
//  placarcito
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("openai_api_key") private var apiKey: String = ""
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Asistente IA Personalizado") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("API Key de OpenAI (Opcional)")
                            .font(.system(size: 13, weight: .medium))
                        SecureField("sk-...", text: $apiKey)
                            .font(.system(size: 13, design: .monospaced))
                        Text("Si ingresas tu clave, el asistente usará OpenAI GPT para consultas estilísticas extendidas. De lo contrario, se usará el motor nativo de estilo.")
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Armario y Datos de Demostración") {
                    Button(role: .destructive) {
                        showingResetAlert = true
                    } label: {
                        Label("Restablecer Armario de Demostración", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                
                Section("Acerca de Placarcito") {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0 (Minimalist Nordic)")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Estilo de Interfaz")
                        Spacer()
                        Text("Scandinavian Monochromatic")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Configuración")
            .navigationBarTitleDisplayMode(.inline)
            .alert("¿Restablecer datos de muestra?", isPresented: $showingResetAlert) {
                Button("Restablecer", role: .destructive) {
                    resetSeedData()
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Esto eliminará todas las prendas actuales y cargará nuevamente el ropero inicial de demostración.")
            }
        }
    }
    
    private func resetSeedData() {
        try? modelContext.delete(model: ClothingItem.self)
        try? modelContext.delete(model: Outfit.self)
        try? modelContext.delete(model: LoggedOutfit.self)
        SeedData.populateIfNeeded(modelContext: modelContext)
    }
}
