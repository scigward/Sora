//
//  SplashScreenView.swift
//  Sora
//
//  Created by paul on 11/06/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            if showMainApp {
                ContentView()
            } else {
                VStack {
                    Image("SplashScreenIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(24)
                        .shadow(color: .accentColor.opacity(0.3), radius: 20, y: 8)
                        .scaleEffect(isAnimating ? 1.0 : 0.85)
                        .opacity(isAnimating ? 1.0 : 0.0)
                }
                .onAppear {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        isAnimating = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            showMainApp = true
                        }
                    }
                }
            }
        }
    }
} 
