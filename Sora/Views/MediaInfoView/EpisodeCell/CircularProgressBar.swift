//
//  CircularProgressBar.swift
//  Sora
//
//  Created by Francesco on 18/12/24.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: Double
    
    var body: some View {
        let remainingTimePercentage = UserDefaults.standard.object(forKey: "remainingTimePercentage") != nil ? UserDefaults.standard.double(forKey: "remainingTimePercentage") : 90.0
        let threshold = remainingTimePercentage / 100.0
        let isComplete = progress >= threshold
        
        ZStack {
            Circle()
                .stroke(lineWidth: 3.0)
                .foregroundStyle(.tertiary)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                .foregroundStyle(isComplete ? Color.green : Color.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 0.3), value: progress)

            if isComplete {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.green)
            } else {
                Text(String(format: "%.0f%%", min(progress, 1.0) * 100.0))
                    .font(.system(size: 9, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }
        }
    }
}
