//
//  ContentView.swift
//  SwiftUI_ParticleEffectExample
//
//  Created by cano on 2025/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ParticleView()
                .navigationTitle("Particle Effect Example")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
