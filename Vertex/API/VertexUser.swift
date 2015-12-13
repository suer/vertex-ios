import SSKeychain

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
            return SSKeychain.passwordForService(KEYCHAIN_SERVICE_NAME, account: KEYCHAIN_USERNAME) ?? ""
        }
        set {
            SSKeychain.setPassword(newValue, forService: KEYCHAIN_SERVICE_NAME, account: KEYCHAIN_USERNAME)
        }
    }
}