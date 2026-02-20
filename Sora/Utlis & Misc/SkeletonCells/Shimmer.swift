//
//  Shimmer.swift
//  Sora
//
//  Created by Francesco on 09/02/25.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                shimmerOverlay
                    .allowsHitTesting(false)
            )
            .onAppear {
                startAnimation()
            }
    }
    
    private var shimmerOverlay: some View {
        Rectangle()
            .fill(shimmerGradient)
            .scaleEffect(x: 3, y: 1)
            .rotationEffect(.degrees(20))
            .offset(x: -200 + (400 * phase))
            .animation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false),
                value: phase
            )
            .clipped()
    }
    
    private var shimmerGradient: LinearGradient {
        let highlightColor = colorScheme == .dark
            ? Color.white.opacity(0.08)
            : Color.white.opacity(0.6)
        let peakColor = colorScheme == .dark
            ? Color.white.opacity(0.15)
            : Color.white.opacity(0.8)
        
        return LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: highlightColor, location: 0.3),
                .init(color: peakColor, location: 0.5),
                .init(color: highlightColor, location: 0.7),
                .init(color: .clear, location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func startAnimation() {
        phase = 1
    }
}
