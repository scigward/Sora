//
//  BookmarkCell.swift
//  Sora
//
//  Created by paul on 18/06/25.
//

import SwiftUI
import NukeUI

struct BookmarkCell: View {
    let bookmark: LibraryItem
    @EnvironmentObject private var moduleManager: ModuleManager
    @EnvironmentObject private var libraryManager: LibraryManager
    
    var body: some View {
        if let module = moduleManager.modules.first(where: { $0.id.uuidString == bookmark.moduleId }) {
            ZStack {
                LazyImage(url: URL(string: bookmark.imageUrl)) { state in
                    if let uiImage = state.imageContainer?.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(0.72, contentMode: .fill)
                            .frame(width: 162, height: 243)
                            .cornerRadius(12)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .frame(width: 162, height: 243)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.tertiary)
                            )
                    }
                }
                .overlay(
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 28, height: 28)
                            .overlay(
                                LazyImage(url: URL(string: module.metadata.iconUrl)) { state in
                                    if let uiImage = state.imageContainer?.image {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 32, height: 32)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 32, height: 32)
                                    }
                                }
                            )
                    }
                    .padding(8),
                    alignment: .topLeading
                )
                
                VStack {
                    Spacer()
                    Text(bookmark.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.black.opacity(0.8), location: 0),
                                    .init(color: Color.black.opacity(0.4), location: 0.6),
                                    .init(color: Color.clear, location: 1.0)
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                }
                .frame(width: 162)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(4)
            .contextMenu {
                Button(role: .destructive, action: {
                    // Find which collection contains this bookmark
                    for collection in libraryManager.collections {
                        if collection.bookmarks.contains(where: { $0.id == bookmark.id }) {
                            libraryManager.removeBookmarkFromCollection(bookmarkId: bookmark.id, collectionId: collection.id)
                            break
                        }
                    }
                }) {
                    Label("Remove from Bookmarks", systemImage: "trash")
                }
            }
        }
    }
} 