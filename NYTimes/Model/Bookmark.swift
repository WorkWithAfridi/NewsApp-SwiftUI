import Foundation

 struct Bookmark {
    var id: UUID
    var article:Article
    var index: Int16
    
     init(id: UUID = UUID(), article: Article, index: Int16) {
        self.id = id
        self.article = article
        self.index = index
    }
}
