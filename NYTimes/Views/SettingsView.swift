import SwiftUI

struct SettingsView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    Menu {
                        Button {
                            LocalizationService.shared.language = .english_us
                        } label: {
                            Text("English (US)")
                        }
                        Button {
                            LocalizationService.shared.language = .german
                        } label: {
                            Text("German (DE)")
                        }
                    } label: {
                        Text("\("app_language".localized(language)): ")
                        Spacer()
                        Text("\("\(LocalizationService.shared.language.rawValue)".lowercased() == "en" ? "English (US)" : "German (DE)" )".localized(language).uppercased())
                    }.padding()
                } header: {
                    Text("locale".localized(language))
                }
            }
        }.navigationTitle("settings".localized(language))
    }
}

#Preview {
    SettingsView()
}
