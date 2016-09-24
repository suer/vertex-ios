import Foundation

class Preference {
    let KEY_OF_VERTEX_ROOT_URL = "VertexRootURL"

    var vertexRootURL : String {
        get {
            let bundle = Bundle.main
            let path = bundle.path(forResource: "preference", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            return dictionary!.object(forKey: KEY_OF_VERTEX_ROOT_URL) as! String
        }
    }
}
