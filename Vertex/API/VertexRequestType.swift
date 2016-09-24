import APIKit

protocol VertexRequestType: Request {
}

extension VertexRequestType {
    var baseURL: URL {
        return NSURL(string: Preference().vertexRootURL)! as URL
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
        return .get
    }

    var path: String {
        return "/tasks.json"
    }

    var parameters: Any? {
        return ["user_nickname": nickname, "user_token": apikey]
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        if let dictionaries = object as? [[String: AnyObject]] {
            return dictionaries.map {dictionary in Task(dictionary: dictionary)}
        }
        return [Task]()
    }
}

struct UpdateTasksRequest: VertexRequestType {
    typealias Response = Task

    var task: Task

    var method: HTTPMethod {
        return .put
    }

    var path: String {
        return "/tasks/\(task.id).json"
    }


    var parameters: Any? {
        return ["user_nickname": nickname, "user_token": apikey, "title": task.title, "done": task.done]
    }


    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return Task()
    }
}
