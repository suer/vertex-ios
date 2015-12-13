import APIKit

protocol VertexRequestType: RequestType {
}

extension VertexRequestType {
    var baseURL: NSURL {
        return NSURL(string: Preference().vertexRootURL)!
    }

    var nickname: String {
        return VertexUser().nickname
    }

    var apikey: String {
        return VertexUser().apikey
    }

}

struct GetTasksRequest: VertexRequestType {
    typealias Response = [Task]

    var method: HTTPMethod {
        return .GET
    }

    var path: String {
        return "/tasks.json"
    }

    var parameters: [String: AnyObject] {
        return ["user_nickname": nickname, "user_token": apikey]
    }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        if let dictionaries = object as? [[String: AnyObject]] {
            return dictionaries.map {dictionary in Task(dictionary: dictionary)}
        }
        return [Task]()
    }
}