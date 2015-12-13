import UIKit

class TasksViewController: UITableViewController {

    override func viewDidLoad() {
        VertexKeyChain().apikey = "" // TODO: remove this line
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        if !didSignin() {
            let controller = LoginViewController()
            controller.modalPresentationStyle = .FullScreen
            navigationController?.presentViewController(controller, animated: false, completion: nil)
        }
    }

    private func didSignin() -> Bool {
        return !VertexKeyChain().apikey.isEmpty
    }
}