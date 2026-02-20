//
//  SettingsView.swift
//  Sora
//
//  Created by Francesco on 05/01/25.
//

import SwiftUI
import NukeUI

fileprivate struct SettingsNavigationRow: View {
    let icon: String
    let titleKey: String
    let isExternal: Bool
    let textColor: Color
    let iconColor: Color
    
    init(icon: String, titleKey: String, isExternal: Bool = false, textColor: Color = .primary, iconColor: Color = .accentColor) {
        self.icon = icon
        self.titleKey = titleKey
        self.isExternal = isExternal
        self.textColor = textColor
        self.iconColor = iconColor
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(iconColor)
                )
            
            Text(NSLocalizedString(titleKey, comment: ""))
                .foregroundStyle(textColor)
            
            Spacer()
            
            if isExternal {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
    }
}

fileprivate struct ModulePreviewRow: View {
    @EnvironmentObject var moduleManager: ModuleManager
    @AppStorage("selectedModuleId") private var selectedModuleId: String?
    
    private var selectedModule: ScrapingModule? {
        guard let id = selectedModuleId else { return nil }
        return moduleManager.modules.first { $0.id.uuidString == id }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            if let module = selectedModule {
                LazyImage(url: URL(string: module.metadata.iconUrl)) { state in
                    if let uiImage = state.imageContainer?.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 52, height: 52)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    } else {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.accentColor.opacity(0.15))
                            .frame(width: 52, height: 52)
                            .overlay(
                                Image(systemName: "cube.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color.accentColor)
                            )
                    }
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(module.metadata.sourceName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Tap to manage your modules")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 52, height: 52)
                    .overlay(
                        Image(systemName: "cube.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Color.accentColor)
                    )
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("No Module Selected")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Tap to select a module")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.accentColor.opacity(0.3), location: 0),
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

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var settings = Settings()
    @EnvironmentObject var moduleManager: ModuleManager
    
    @State private var isNavigationActive = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("MODULES")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        NavigationLink(destination: SettingsViewModule().navigationBarBackButtonHidden(false)) {
                            ModulePreviewRow()
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("MAIN SETTINGS")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: SettingsViewGeneral().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "gearshape.fill", titleKey: "General Preferences", iconColor: .gray)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            NavigationLink(destination: SettingsViewLibrary().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "books.vertical.fill", titleKey: "Library", iconColor: .orange)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            NavigationLink(destination: SettingsViewPlayer().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "play.circle.fill", titleKey: "Video Player", iconColor: .blue)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            NavigationLink(destination: SettingsViewDownloads().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "arrow.down.circle.fill", titleKey: "Downloads", iconColor: .green)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            NavigationLink(destination: SettingsViewTrackers().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "square.3.stack.3d.top.filled", titleKey: "Trackers", iconColor: .purple)
                            }
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color.accentColor.opacity(0.3), location: 0),
                                            .init(color: Color.accentColor.opacity(0), location: 1)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("DATA & LOGS")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: SettingsViewData().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "folder.fill", titleKey: "Data", iconColor: .cyan)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            NavigationLink(destination: SettingsViewLogger().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "doc.text.fill", titleKey: "Logs", iconColor: .indigo)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            NavigationLink(destination: SettingsViewBackup().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "arrow.triangle.2.circlepath", titleKey: NSLocalizedString("Backup & Restore", comment: "Settings navigation row for backup and restore"), iconColor: .mint)
                            }
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color.accentColor.opacity(0.3), location: 0),
                                            .init(color: Color.accentColor.opacity(0), location: 1)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(NSLocalizedString("INFOS", comment: ""))
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 0) {
                            NavigationLink(destination: SettingsViewAbout().navigationBarBackButtonHidden(false)) {
                                SettingsNavigationRow(icon: "info.circle.fill", titleKey: "About Sora", iconColor: .blue)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            Link(destination: URL(string: "https://github.com/cranci1/Sora")!) {
                                HStack(spacing: 12) {
                                    Image("Github Icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 16, height: 16)
                                        .padding(7)
                                        .background(
                                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                .fill(Color(.systemGray))
                                        )
                                    
                                    Text(NSLocalizedString("Sora GitHub Repository", comment: ""))
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 11)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            Link(destination: URL(string: "https://discord.gg/x7hppDWFDZ")!) {
                                HStack(spacing: 12) {
                                    Image("Discord Icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 16, height: 16)
                                        .padding(7)
                                        .background(
                                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                .fill(Color(red: 0.34, green: 0.40, blue: 0.95))
                                        )
                                    
                                    Text(NSLocalizedString("Join the Discord", comment: ""))
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 11)
                            }
                            Divider().padding(.horizontal, 16)
                            
                            Link(destination: URL(string: "https://github.com/cranci1/Sora/issues")!) {
                                SettingsNavigationRow(
                                    icon: "exclamationmark.triangle.fill",
                                    titleKey: "Report an Issue",
                                    isExternal: true,
                                    iconColor: .yellow
                                )
                            }
                            Divider().padding(.horizontal, 16)
                            
                            Link(destination: URL(string: "https://github.com/cranci1/Sora/blob/dev/LICENSE")!) {
                                SettingsNavigationRow(
                                    icon: "doc.text.fill",
                                    titleKey: "License (GPLv3.0)",
                                    isExternal: true,
                                    iconColor: .brown
                                )
                            }
                        }
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: Color.accentColor.opacity(0.3), location: 0),
                                            .init(color: Color.accentColor.opacity(0), location: 1)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    Text("Sora 1.0.1 by cranci1")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                }
                .scrollViewBottomPadding()
                .padding(.bottom, 20)
            }
            .deviceScaled()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .onChange(of: colorScheme) { newScheme in
            if settings.selectedAppearance == .system {
                settings.updateAccentColor(currentColorScheme: newScheme)
            }
        }
        .onChange(of: settings.selectedAppearance) { _ in
            settings.updateAccentColor(currentColorScheme: colorScheme)
        }
        .onAppear {
            settings.updateAccentColor(currentColorScheme: colorScheme)
        }
    }
}

enum Appearance: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: String { self.rawValue }
}

class Settings: ObservableObject {
    @Published var accentColor: Color {
        didSet {
        }
    }
    @Published var selectedAppearance: Appearance {
        didSet {
            UserDefaults.standard.set(selectedAppearance.rawValue, forKey: "selectedAppearance")
            updateAppearance()
        }
    }
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            updateLanguage()
        }
    }
    
    init() {
        self.accentColor = .primary
        if let appearanceRawValue = UserDefaults.standard.string(forKey: "selectedAppearance"),
           let appearance = Appearance(rawValue: appearanceRawValue) {
            self.selectedAppearance = appearance
        } else {
            self.selectedAppearance = .system
        }
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
        updateAppearance()
        updateLanguage()
    }
    
    func updateAccentColor(currentColorScheme: ColorScheme? = nil) {
        switch selectedAppearance {
        case .system:
            if let scheme = currentColorScheme {
                accentColor = scheme == .dark ? .white : .black
            } else {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else { return }
                accentColor = window.traitCollection.userInterfaceStyle == .dark ? .white : .black
            }
        case .light:
            accentColor = .black
        case .dark:
            accentColor = .white
        }
    }
    
    func updateAppearance() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        switch selectedAppearance {
        case .system:
            windowScene.windows.first?.overrideUserInterfaceStyle = .unspecified
        case .light:
            windowScene.windows.first?.overrideUserInterfaceStyle = .light
        case .dark:
            windowScene.windows.first?.overrideUserInterfaceStyle = .dark
        }
    }
    
    func updateLanguage() {
        let languageCode: String
        switch selectedLanguage {
        case "Dutch":
            languageCode = "nl"
        case "French":
            languageCode = "fr"
        case "German":
            languageCode = "de"
        case "Arabic":
            languageCode = "ar"
        case "Bosnian":
            languageCode = "bos"
        case "Czech":
            languageCode = "cs"
        case "Slovak":
            languageCode = "sk"
        case "Spanish":
            languageCode = "es"
        case "Russian":
            languageCode = "ru"
        case "Norsk":
            languageCode = "nn"
        case "Kazakh":
            languageCode = "kk"
        case "Mongolian":
            languageCode = "mn"
            
            let mainBundle = Bundle.main
            if let lprojPaths = mainBundle.paths(forResourcesOfType: "lproj", inDirectory: nil) as? [String] {
                let availableLangs = lprojPaths.map { path -> String in
                    let components = path.components(separatedBy: "/")
                    let filename = components.last ?? ""
                    return filename.replacingOccurrences(of: ".lproj", with: "")
                }
                Logger.shared.log("Available language bundles: \(availableLangs.joined(separator: ", "))", type: "Debug")
            }

            if let _ = mainBundle.path(forResource: "mn", ofType: "lproj") {
                Logger.shared.log("Found mn.lproj bundle", type: "Debug")
            } else {
                Logger.shared.log("mn.lproj bundle not found", type: "Error")
            }
        case "Romanian":
            languageCode = "ro"

            let mainBundle = Bundle.main
            if let lprojPaths = mainBundle.paths(forResourcesOfType: "lproj", inDirectory: nil) as? [String] {
                let availableLangs = lprojPaths.map { path -> String in
                    let components = path.components(separatedBy: "/")
                    let filename = components.last ?? ""
                    return filename.replacingOccurrences(of: ".lproj", with: "")
                }
                Logger.shared.log("Available language bundles: \(availableLangs.joined(separator: ", "))", type: "Debug")
            }

            if let _ = mainBundle.path(forResource: "ro", ofType: "lproj") {
                Logger.shared.log("Found ro.lproj bundle", type: "Debug")
            } else {
                Logger.shared.log("ro.lproj bundle not found", type: "Error")
            }
        case "Swedish":
            languageCode = "sv"
        case "Italian":
            languageCode = "it"
        default:
            languageCode = "en"
        }
        
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        Logger.shared.log("Setting language to: \(languageCode) for \(selectedLanguage)", type: "Debug")
        
        UserDefaults.standard.synchronize()
        
        LocalizationManager.shared.setLanguage(languageCode)
        
        if selectedLanguage == "Mongolian" {
            if let mongolianBundle = Bundle(path: Bundle.main.path(forResource: "mn", ofType: "lproj") ?? "") {
                Logger.shared.log("Mongolian bundle: \(mongolianBundle)", type: "Debug")
                
                let testKey = "About"
                let testString = mongolianBundle.localizedString(forKey: testKey, value: nil, table: nil)
                Logger.shared.log("Test Mongolian string for '\(testKey)': \(testString)", type: "Debug")
            }
        }

        if selectedLanguage == "Romanian" {
            if let romanianBundle = Bundle(path: Bundle.main.path(forResource: "ro", ofType: "lproj") ?? "") {
                Logger.shared.log("Romanian bundle: \(romanianBundle)", type: "Debug")

                let testKey = "About"
                let testString = romanianBundle.localizedString(forKey: testKey, value: nil, table: nil)
                Logger.shared.log("Test Romanian string for '\(testKey)': \(testString)", type: "Debug")
            }
        }
    }
}
