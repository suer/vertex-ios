import KeychainAccess

class VertexUser {
    fileprivate let KEY_OF_NICKNAME = "VERTEX_NICKNAME"

    fileprivate let KEYCHAIN_SERVICE_NAME = "Vertex_KeychainService"
    fileprivate let KEYCHAIN_USERNAME = "vertex"

    var nickname: String {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.string(forKey: KEY_OF_NICKNAME) ?? ""
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: KEY_OF_NICKNAME)
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
