import SwiftUI

struct CategoriesView: View {

    @EnvironmentObject var viewModel: CategoriesViewModel
    @AppStorage("language")
    private var language = LocalizationService.shared.language


    var body: some View {
        List {
            Section {
                ForEach(viewModel.categories, id: \.rawValue) { category in
                    Text("\(category.rawValue)".localized(language))
                }.onMove(perform: viewModel.move)
                    .onDelete(perform: viewModel.delete)
            } header: {
                Text("my_categories".localized(language))
            }
            
            Section {
                ForEach(viewModel.categoriesUnfollowed, id: \.self) { category in
                    HStack {
                        Text(category.rawValue)
                        Spacer()
                        Button {
                            viewModel.addCategory(category)
                        } label: {
                            Image(systemName: "plus.circle")
                        }

                    }
                }
            } header: {
                Text("Categories")
            }

        }
        .toolbar { EditButton() }
        .navigationBarTitle("Categories", displayMode: .automatic)
    }
}
