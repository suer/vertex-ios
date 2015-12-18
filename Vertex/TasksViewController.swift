import UIKit
import APIKit
import SVProgressHUD
import MCSwipeTableViewCell

class TasksViewController: UITableViewController, MCSwipeTableViewCellDelegate {

    private var tasks = [Task]()
    private var cellSwipePercentage = CGFloat(0.0)

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
        SVProgressHUD.showWithStatus("Fetching tasks...", maskType: .Black)
        let request = GetTasksRequest()
        Session.sendRequest(request) { result in
            switch result {
            case .Success(let tasks):
                SVProgressHUD.showSuccessWithStatus("Success")
                self.tasks = tasks
                self.tableView.reloadData()
            case .Failure(let error):
                SVProgressHUD.showErrorWithStatus("Error")
                print(error)
            }
        }
    }

    private func toggleTaskDone(taskCell: TaskCell) {
        let param = Task()
        param.id = taskCell.task.id
        param.title = taskCell.task.title
        param.done = !taskCell.task.done

        SVProgressHUD.showWithStatus("Updating tasks...", maskType: .Black)
        let request = UpdateTasksRequest(task: param)
        Session.sendRequest(request) { result in
            switch result {
            case .Success(_):
                self.tasks[taskCell.row] = param
                self.tableView.reloadData()
                SVProgressHUD.showSuccessWithStatus("Success")
            case .Failure(let error):
                SVProgressHUD.showErrorWithStatus("Error")
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
        let cell = TaskCell(task: task, row: indexPath.row, style: .Value1, reuseIdentifier: "Cell")
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }

    func configureCell(cell: MCSwipeTableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let checkView = self.viewWithImageName("check")
        let greenColor = UIColor(red: 85.0 / 255.0, green:213.0 / 255.0, blue:80.0 / 255.0, alpha:1.0)
        cell.delegate = self
        cell.setSwipeGestureWithView(checkView, color: greenColor, mode: .Switch, state: .State1, completionBlock: nil)

    }

    private func viewWithImageName(imageName: String) -> UIView {
        let imageView = UIImageView(image: UIImage(named: "check"))
        imageView.contentMode = .Center
        return imageView
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func swipeTableViewCellDidStartSwiping(cell: MCSwipeTableViewCell!) {
        self.cellSwipePercentage = 0.0
    }

    func swipeTableViewCellDidEndSwiping(cell: MCSwipeTableViewCell!) {
        if self.cellSwipePercentage >= cell.firstTrigger {
            if let taskCell = cell as? TaskCell {
                toggleTaskDone(taskCell)
            }
        }
    }

    func swipeTableViewCell(cell: MCSwipeTableViewCell!, didSwipeWithPercentage percentage: CGFloat) {
        self.cellSwipePercentage = percentage
    }
}