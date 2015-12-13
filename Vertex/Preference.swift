import Foundation

class Preference {
    let KEY_OF_VERTEX_ROOT_URL = "VertexRootURL"

    var vertexRootURL : String {
        get {
            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource("preference", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            return dictionary!.objectForKey(KEY_OF_VERTEX_ROOT_URL) as! String
        }
    }
}