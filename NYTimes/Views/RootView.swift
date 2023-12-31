import SwiftUI
import CoreData

struct RootView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var articlesViewModel = ArticleViewModel()
    @ObservedObject var bookmarkViewModel = BookmarkViewModel()
    @ObservedObject var networkReachability = NetworkReachabilty.shared
    @ObservedObject var categoriesViewModel = CategoriesViewModel()
    
    @State var shouldShowBookmarks = false
    @State var showSettings = false
    @State var openCategories = false
    @State var isLoaded = false
    
    init() {
        articlesViewModel.loadArticles(for: categoriesViewModel.selectedCategory)
    }
    
    var body: some View {
        NavigationView {
            if networkReachability.isNetworkConnected {
                ArticleView()
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle(Text("NYTimes"))
                    .navigationBarItems(
                        leading: categoriesView,
                        trailing: bookmarksView
                    )
            } else {
                VStack {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 50))
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding(.bottom, 24)
                    Text("Network not available")
                        .alert(isPresented: .constant(true)) {
                            Alert(title: Text("Network not available"), message: Text("Turn on mobile data or use Wi-Fi to access data"), dismissButton: .default(Text("OK")))
                        }.navigationBarTitle(Text("NYTimes"))
                }
            }
        }.onAppear {
            let repo = BookmarkRepository(context: managedObjectContext)
            bookmarkViewModel.repository = repo
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(650)) {
                isLoaded = true
            }
            articlesViewModel.loadArticles(for: categoriesViewModel.selectedCategory)
        }
    }
    
    private var categoriesView: some View {
        Button(action: { openCategories = true }, label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .frame(width: 30, height: 50, alignment: .center)
        })
    }
    
    private var bookmarksView: some View {
        HStack {
            Button(action: { shouldShowBookmarks = true }, label: {
                Image(systemName: "books.vertical")
                    .frame(width: 30, height: 50, alignment: .center)
            })
            Button(action: { showSettings = true }, label: {
                Image(systemName: "gearshape")
                    .frame(width: 30, height: 50, alignment: .center)
            })
            
        }
    }
    
    fileprivate func ArticleView() -> some View {
        return VStack {
            NavigationLink(destination: BookmarksView(), isActive: $shouldShowBookmarks) {}
            NavigationLink(destination: SettingsView(), isActive: $showSettings) {}
            NavigationLink(destination: CategoriesView().environmentObject(categoriesViewModel), isActive: $openCategories) {}

            if articlesViewModel.isArticlesLoading {
                VStack{
                    ForEach(0..<4) { i in
                        NewsFeedView(article: .placeholder)
                    }.redacted(reason: .placeholder)
                    Spacer()
                }
            } else {
                ArticleListView(articlesViewModel: articlesViewModel, bookmarkViewModel: bookmarkViewModel)
            }
            Spacer()
            CategorySelector()
                .environmentObject(articlesViewModel)
                .environmentObject(categoriesViewModel)
                .frame(height: 100).offset(y: isLoaded ? 0 : 100)
                .animation(isLoaded ? .spring() : .none)
        }
    }
}


struct ArticleListView: View {
    @AppStorage("language")
    private var language = LocalizationService.shared.language

    
    @ObservedObject var articlesViewModel: ArticleViewModel
    @ObservedObject var bookmarkViewModel: BookmarkViewModel
    
    var body: some View {
        ScrollView {
            ForEach(articlesViewModel.articles,id: \.id) { article in
                NavigationLink(destination: WebViewHolder(url: URL(string: article.url)!, article: article)){
                    NewsFeedView(article: article)
                        .contextMenu(menuItems: {
                            Button(action: {
                                bookmarkViewModel.bookmark(for: article)
                            }) {
                                Text("bookmarks".localized(language))
                                Image(uiImage:UIImage(systemName:"bookmark")!)
                            }
                            .alert(isPresented: $bookmarkViewModel.shouldShowAlert) {
                                return Alert(
                                    title: Text(bookmarkViewModel.message),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        })
                }
            }
            
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RootView()
                .previewDevice(.init(stringLiteral: "iPhone 11"))
        }
    }
}
