import UIKit
import APIKit

class TasksViewController: UITableViewController {

    private var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBarButtons()
    }

    override func viewWillAppear(animated: Bool) {
        if didSignin() {
            fetch()
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
        VertexUser().apikey = ""
        presentLoginViewController()
    }

    private func fetch() {
        let request = GetTasksRequest()
        Session.sendRequest(request) { result in
            switch result {
            case .Success(let tasks):
                self.tasks = tasks
                self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
    }

    private func didSignin() -> Bool {
        return !VertexUser().apikey.isEmpty
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = task.title
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}