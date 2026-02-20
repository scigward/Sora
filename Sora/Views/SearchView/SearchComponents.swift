//
//  SearchComponents.swift
//  Sora
//
//  Created by Francesco on 27/01/25.
//

import SwiftUI

struct SearchItem: Identifiable {
    let id = UUID()
    let title: String
    let imageUrl: String
    let href: String
}

struct SearchHistorySection<Content: View>: View {
    let title: String
    let content: Content
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.footnote)
                .foregroundStyle(Color.secondary)
                .padding(.horizontal, 20)
            VStack(spacing: 0) {
                content
            }
        }
        .padding(.vertical, 16)
    }
}


struct SearchHistoryRow: View {
    let text: String
    let onTap: () -> Void
    let onDelete: () -> Void
    var showDivider: Bool = true
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.primary)
            
            Text(text)
                .foregroundStyle(Color.primary)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        
        if showDivider {
            Divider()
                .padding(.horizontal, 16)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search", text: $text)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .onChange(of: text) { _ in
                        NotificationCenter.default.post(name: .tabBarSearchQueryUpdated, object: nil, userInfo: ["searchQuery": text])
                    }
                    .onSubmit {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                        isFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.accentColor.opacity(0.25), location: 0),
                                .init(color: Color.accentColor.opacity(0), location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 0.5
                    )
            )
        }
    }
}
