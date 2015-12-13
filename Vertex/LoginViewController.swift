import UIKit
import Ji

class LoginViewController : UIViewController, UIWebViewDelegate {
    private let webview = UIWebView(frame: CGRectZero)
    private let rootURL = NSURL(string: Preference().vertexRootURL)!
    private var signedIn = false

    override func viewDidLoad() {
        title = "Sign in"

        webview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webview.frame = view.bounds
        webview.delegate = self
        view.addSubview(webview)


        removeCookie(rootURL)

        let request = NSMutableURLRequest(URL: rootURL)
        webview.loadRequest(request)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.signedIn = false
    }

    private func removeCookie(url: NSURL) {
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookiesForURL(url)!
        for cookie in cookies {
            cookieStorage.deleteCookie(cookie)
        }
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if signedIn {
            return true
        }

        let tasksURL = NSURL(string: "/tasks", relativeToURL: rootURL)
        if (request.URL?.absoluteString ?? "") == tasksURL!.absoluteString {
            let tokenURL = NSURL(string: "/token/index", relativeToURL: rootURL)
            let doc = Ji(htmlURL: tokenURL!)
            if let apikey = doc?.xPath("//p")?.first?.value {
                VertexKeyChain().apikey = apikey
                dismissViewControllerAnimated(true, completion: nil)
            }
            return false
        }
        return true
    }
}