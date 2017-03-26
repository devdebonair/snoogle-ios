import Foundation

struct MultiredditEdits {
    let name: String?
    let title: String?
    let description: String?
    let visibility: String?
    let icon: String?
    let color: String?
    let weight: String?
    
    init(name: String? = nil, title: String? = nil, description: String? = nil, visibility: String? = nil, icon: String? = nil, color: String? = nil, weight: String? = nil) {
        self.name = name
        self.title = title
        self.description = description
        self.visibility = visibility
        self.icon = icon
        self.color = color
        self.weight = weight
    }
}
