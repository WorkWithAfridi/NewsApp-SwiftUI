import Foundation

enum Category: String, CaseIterable {
    
    case tech = "tech"
    case science = "science"
    case business = "business"
    case yourmoney = "your_money"
    case education = "education"
    case sports = "sports"
    case space = "space"
    
    var url: String {
        switch self {
        case .science : return "https://www.nytimes.com/section/science"
        case .tech: return "https://www.nytimes.com/section/technology"
        case .business: return "https://www.nytimes.com/section/business/smallbusiness"
        case .yourmoney: return "https://www.nytimes.com/section/your-money"
        case .education: return "https://www.nytimes.com/section/education?module=SiteIndex&pgtype=Section%20Front&region=Footer"
        case .sports: return "https://www.nytimes.com/section/sports/soccer"
        case .space: return "https://www.nytimes.com/section/science/space"
        }
    }
}
