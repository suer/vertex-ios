import UIKit

class LoginViewController : UIViewController, UIWebViewDelegate {
    let webview = UIWebView(frame: CGRectZero)

    override func viewDidLoad() {
        title = "Sign in"

        webview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webview.frame = view.bounds
        webview.delegate = self
        view.addSubview(webview)

        let rootURL = NSURL(string: Preference().vertexRootURL)!

        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        let cookies = cookieStorage.cookiesForURL(rootURL)!
        for cookie in cookies {
            cookieStorage.deleteCookie(cookie)
        }

        let request = NSMutableURLRequest(URL: rootURL)
        webview.loadRequest(request)
    }
}