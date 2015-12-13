import Foundation
import SSKeychain

class VertexKeyChain {

    private let KEYCHAIN_SERVICE_NAME = "Vertex_KeychainService"
    private let USERNAME = "vertex"

    var apikey: String {
        get {
            return SSKeychain.passwordForService(KEYCHAIN_SERVICE_NAME, account: USERNAME) ?? ""
        }
        set {
            SSKeychain.setPassword(newValue, forService: KEYCHAIN_SERVICE_NAME, account: USERNAME)
        }
    }
}