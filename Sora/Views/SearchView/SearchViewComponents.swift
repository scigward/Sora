//
//  SearchViewComponents.swift
//  Sora
//
//  Created by Francesco on 27/01/25.
//

import NukeUI
import SwiftUI

struct ModuleSelectorMenu: View {
    let selectedModule: ScrapingModule?
    let moduleGroups: [String]
    let modulesByLanguage: [String: [ScrapingModule]]
    let selectedModuleId: String?
    let onModuleSelected: (String) -> Void
    
    @Namespace private var animation
    let gradientOpacity: Double = 0.5
    
    var body: some View {
        Menu {
            ForEach(moduleGroups, id: \.self) { language in
                Menu(language) {
                    ForEach(modulesByLanguage[language] ?? [], id: \.id) { module in
                        Button {
                            onModuleSelected(module.id.uuidString)
                        } label: {
                            HStack {
                                LazyImage(url: URL(string: module.metadata.iconUrl)) { state in
                                    if let uiImage = state.imageContainer?.image {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .cornerRadius(4)
                                    } else {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                    }
                                }
                                
                                Text(module.metadata.sourceName)
                                if module.id.uuidString == selectedModuleId {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                if let selectedModule = selectedModule {
                    Text(selectedModule.metadata.sourceName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    LazyImage(url: URL(string: selectedModule.metadata.iconUrl)) { state in
                        if let uiImage = state.imageContainer?.image {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 36, height: 36)
                        }
                    }
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color.accentColor.opacity(gradientOpacity), location: 0),
                                                .init(color: Color.accentColor.opacity(0), location: 1)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 0.5
                                    )
                            )
                            .matchedGeometryEffect(id: "background_circle", in: animation)
                    )
                } else {
                    Text("Select Module")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Image(systemName: "questionmark.app.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .foregroundColor(.secondary)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(stops: [
                                                    .init(color: Color.accentColor.opacity(gradientOpacity), location: 0),
                                                    .init(color: Color.accentColor.opacity(0), location: 1)
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 0.5
                                        )
                                )
                                .matchedGeometryEffect(id: "background_circle", in: animation)
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .cornerRadius(12)
        }
    }
}

struct SearchContent: View {
    let selectedModule: ScrapingModule?
    let searchQuery: String
    let searchHistory: [String]
    let searchItems: [SearchItem]
    let isSearching: Bool
    let hasNoResults: Bool
    let columns: [GridItem]
    let columnsCount: Int
    let cellWidth: CGFloat
    let onHistoryItemSelected: (String) -> Void
    let onHistoryItemDeleted: (Int) -> Void
    let onClearHistory: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if selectedModule == nil {
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.app")
                        .font(.system(size: 40))
                        .foregroundStyle(.tertiary)
                    
                    VStack(spacing: 4) {
                        Text("No Module Selected")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Please select a module from settings")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            }
            
            if searchQuery.isEmpty {
                if !searchHistory.isEmpty {
                    SearchHistorySection(title: "Recent Searches") {
                        VStack(spacing: 0) {
                            ForEach(searchHistory.indices, id: \.self) { index in
                                SearchHistoryRow(
                                    text: searchHistory[index],
                                    onTap: {
                                        onHistoryItemSelected(searchHistory[index])
                                    },
                                    onDelete: {
                                        onHistoryItemDeleted(index)
                                    },
                                    showDivider: index < searchHistory.count - 1
                                )
                            }
                            
                            Divider()
                                .padding(.horizontal, 16)
                            
                            Button(action: onClearHistory) {
                                Text("Clear All")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 11)
                        }
                    }
                    .padding(.vertical)
                }
            } else {
                if let module = selectedModule {
                    if !searchItems.isEmpty {
                        SearchResultsGrid(
                            items: searchItems,
                            columns: columns,
                            selectedModule: module,
                            cellWidth: cellWidth
                        )
                    } else {
                        SearchStateView(
                            isSearching: isSearching,
                            hasNoResults: hasNoResults,
                            columnsCount: columnsCount,
                            cellWidth: cellWidth
                        )
                    }
                }
            }
        }
    }
}
