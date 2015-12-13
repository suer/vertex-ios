import UIKit

class TasksViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        loadBarButtons()
    }

    override func viewWillAppear(animated: Bool) {
        if didSignin() {
            // tasksViewModel.fetchTasks()
        } else {
            presentLoginViewController()
        }
    }

    private func presentLoginViewController() {
        let controller = LoginViewController()
        controller.modalPresentationStyle = .FullScreen
        navigationController?.presentViewController(controller, animated: false, completion: nil)
    }

    private func loadBarButtons() {
        let signoutButton = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: Selector("signoutButtonTapped"))
        navigationItem.leftBarButtonItem = signoutButton
    }

    func signoutButtonTapped() {
        VertexKeyChain().apikey = ""
        presentLoginViewController()
    }

    private func didSignin() -> Bool {
        return !VertexKeyChain().apikey.isEmpty
    }
}