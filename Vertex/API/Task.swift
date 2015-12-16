class Task {
    var id: Int
    var title: String
    var done: Bool

    init() {
        self.id = 0
        self.title = ""
        self.done = false
    }

    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.done = dictionary["done"] as? Bool ?? false
    }
}