//
//  SkeletonCell.swift
//  Sora
//
//  Created by Francesco on 09/02/25.
//

import SwiftUI

struct HomeSkeletonCell: View {
    let cellWidth: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.ultraThinMaterial)
            .frame(width: cellWidth, height: cellWidth * 1.5)
            .shimmering()
    }
}

struct SearchSkeletonCell: View {
    let cellWidth: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.ultraThinMaterial)
            .frame(width: cellWidth, height: cellWidth * 1.5)
            .shimmering()
    }
}
