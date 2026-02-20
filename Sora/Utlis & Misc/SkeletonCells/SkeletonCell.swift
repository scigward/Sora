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
            .fill(Color.gray.opacity(0.2))
            .frame(width: cellWidth, height: cellWidth * 1.5)
            .shimmering()
    }
}

struct SearchSkeletonCell: View {
    let cellWidth: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(width: cellWidth, height: cellWidth * 1.5)
            .shimmering()
    }
}
