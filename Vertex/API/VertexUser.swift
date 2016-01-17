import KeychainAccess

class VertexUser {
    private let KEY_OF_NICKNAME = "VERTEX_NICKNAME"

    private let KEYCHAIN_SERVICE_NAME = "Vertex_KeychainService"
    private let KEYCHAIN_USERNAME = "vertex"

    var nickname: String {
        get {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            return userDefaults.stringForKey(KEY_OF_NICKNAME) ?? ""
        }
        set {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(newValue, forKey: KEY_OF_NICKNAME)
        }
    }

    var apikey: String {
        get {
            return Keychain(service: KEYCHAIN_SERVICE_NAME)[KEYCHAIN_USERNAME] ?? ""
        }
        set {
            Keychain(service: KEYCHAIN_SERVICE_NAME)[KEYCHAIN_USERNAME] = newValue
        }
    }
}