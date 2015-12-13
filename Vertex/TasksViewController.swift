import UIKit

class TasksViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        if !didLogin() {
            let controller = LoginViewController()
            controller.modalPresentationStyle = .FullScreen
            navigationController?.presentViewController(controller, animated: false, completion: nil)
        }
    }

    private func didLogin() -> Bool {
        return false
    }
}