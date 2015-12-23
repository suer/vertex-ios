import UIKit
import APIKit
import SVProgressHUD
import MCSwipeTableViewCell
import PullToRefreshSwift

class TasksViewController: UITableViewController, MCSwipeTableViewCellDelegate {

    private var tasks = [Task]()
    private var cellSwipePercentage = CGFloat(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vertex"
        loadBarButtons()
        addPullToRefresh()
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
    
    private func addPullToRefresh() {
        let options = PullToRefreshOption()
        options.backgroundColor = UIColor.whiteColor()
        options.indicatorColor = UIColor.whiteColor()
        self.tableView.addPullToRefresh(options: options) { [weak self] in
            self?.fetch()
        }
    }

    private func loadBarButtons() {
        let signoutButton = UIBarButtonItem(title: "Sign out", style: .Plain, target: self, action: Selector("signoutButtonTapped"))
        navigationItem.leftBarButtonItem = signoutButton
    }

    func signoutButtonTapped() {
        let alert = UIAlertController(title: "Are you sure to signout from Vetex?", message: "", preferredStyle: .ActionSheet)

        let signoutAction = UIAlertAction(title: "Signout", style: .Default) {
            action in
            VertexUser().apikey = ""
            self.presentLoginViewController()
        }
        alert.addAction(signoutAction)

        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Cancel) { action in return }
        alert.addAction(cancelAction)

        presentViewController(alert, animated: true, completion: nil)
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

    func configureCell(cell: TaskCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.delegate = self
        if cell.task.done {
            let redColor = UIColor(red:232.0 / 255.0, green:61.0 / 255.0,blue: 14.0 / 255.0, alpha:1.0)
            cell.setSwipeGestureWithView(self.viewWithImageName("times"), color: redColor, mode: .Switch, state: .State1, completionBlock: nil)
        } else {
            let greenColor = UIColor(red:85.0 / 255.0, green:213.0 / 255.0, blue:80.0 / 255.0, alpha:1.0)
            cell.setSwipeGestureWithView(self.viewWithImageName("check"), color: greenColor, mode: .Switch, state: .State1, completionBlock: nil)
        }
    }

    private func viewWithImageName(imageName: String) -> UIView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .Left
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