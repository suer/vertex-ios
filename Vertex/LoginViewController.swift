import UIKit
import Kanna

class LoginViewController : UIViewController, UIWebViewDelegate {
    fileprivate let webview = UIWebView(frame: CGRect.zero)
    fileprivate let rootURL = URL(string: Preference().vertexRootURL)!
    fileprivate var signedIn = false

    override func viewDidLoad() {
        title = "Sign in"

        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webview.frame = view.bounds
        webview.delegate = self
        view.addSubview(webview)


        removeCookie(rootURL)

        let request = NSMutableURLRequest(url: rootURL)
        webview.loadRequest(request as URLRequest)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.signedIn = false
    }

    fileprivate func removeCookie(_ url: URL) {
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: url)!
        for cookie in cookies {
            cookieStorage.deleteCookie(cookie)
        }
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if signedIn {
            return true
        }

        let tasksURL = URL(string: "/tasks", relativeTo: rootURL)
        if (request.url?.absoluteString ?? "") == tasksURL!.absoluteString {
            let tokenURL = URL(string: "/token/index", relativeTo: rootURL)
            if let doc = try? HTML(url: tokenURL!, encoding: String.Encoding.utf8) {
                if let nickname = doc.xpath("//span[@id='nickname']").first, let apikey = doc.xpath("//span[@id='token']").first {
                    let user = VertexUser()
                    user.nickname = nickname.text ?? ""
                    user.apikey = apikey.text ?? ""
                    dismiss(animated: true, completion: nil)
                }
            }
            return false
        }
        return true
    }
}
