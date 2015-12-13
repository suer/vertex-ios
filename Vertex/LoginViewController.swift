import UIKit

class LoginViewController : UIViewController, UIWebViewDelegate {
    let webview = UIWebView(frame: CGRectZero)

    override func viewDidLoad() {
        title = "Sign in"

        webview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webview.frame = view.bounds
        webview.delegate = self
        view.addSubview(webview)


        let request = NSMutableURLRequest(URL: NSURL(string: "https://cf-vertex.herokuapp.com/")!)
        webview.loadRequest(request)
    }
}