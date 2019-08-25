import UIKit
import APIKit
import SVProgressHUD
import MCSwipeTableViewCell
import AudioToolbox

public struct PullToRefreshOption {
    public var backgroundColor =  UIColor.white
    public var indicatorColor =  UIColor.white
    public var autoStopTime: Double = 0
    public var fixedSectionHeader = false
}

class TasksViewController: UITableViewController, MCSwipeTableViewCellDelegate {

    fileprivate var tasks = [Task]()
    fileprivate var cellSwipePercentage = CGFloat(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Vertex"
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
        loadBarButtons()
        setupPullToRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        if didSignin() {
            fetch()
        } else {
            presentLoginViewController()
        }
    }

    fileprivate func presentLoginViewController() {
        let controller = LoginViewController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.present(controller, animated: false, completion: nil)
    }
    
    fileprivate func setupPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }

    fileprivate func loadBarButtons() {
        let signoutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(TasksViewController.signoutButtonTapped))
        navigationItem.leftBarButtonItem = signoutButton
    }

    @objc func signoutButtonTapped() {
        let alert = UIAlertController(title: "Are you sure to signout from Vetex?", message: "", preferredStyle: .actionSheet)

        let signoutAction = UIAlertAction(title: "Signout", style: .default) {
            action in
            VertexUser().apikey = ""
            self.presentLoginViewController()
        }
        alert.addAction(signoutAction)

        let cancelAction = UIAlertAction(title: "Cancel",
            style: .cancel) { action in return }
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc fileprivate func fetch() {
        SVProgressHUD.show(withStatus: "Fetching tasks...")
        let request = GetTasksRequest()
        Session.send(request) { result in
            switch result {
            case .success(let tasks):
                SVProgressHUD.showSuccess(withStatus: "Success")
                self.tasks = tasks
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Error")
                self.tableView.refreshControl?.endRefreshing()
                print(error)
            }
        }
    }

    fileprivate func toggleTaskDone(_ taskCell: TaskCell) {
        let param = Task()
        param.id = taskCell.task.id
        param.title = taskCell.task.title
        param.done = !taskCell.task.done

        taskCell.setDone(!taskCell.task.done)

        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let request = UpdateTasksRequest(task: param)
        Session.send(request) { result in
            switch result {
            case .success(_):
                self.tasks[taskCell.row] = param
            case .failure(let error):
                taskCell.setDone(!taskCell.task.done)
                print(error)
            }
        }
    }

    fileprivate func didSignin() -> Bool {
        return !VertexUser().apikey.isEmpty
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[(indexPath as NSIndexPath).row]
        let cell = TaskCell(task: task, row: (indexPath as NSIndexPath).row, style: .value1, reuseIdentifier: "Cell")
        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }

    func configureCell(_ cell: TaskCell, forRowAtIndexPath indexPath: IndexPath) {
        cell.delegate = self
        if cell.task.done {
            let redColor = UIColor(red:232.0 / 255.0, green:61.0 / 255.0,blue: 14.0 / 255.0, alpha:1.0)
            cell.setSwipeGestureWith(self.viewWithImageName("times"), color: redColor, mode: .switch, state: .state1, completionBlock: nil)
            cell.backgroundColor = UIColor(white: 242.0 / 255.0, alpha: 1.0)
        } else {
            let greenColor = UIColor(red:85.0 / 255.0, green:213.0 / 255.0, blue:80.0 / 255.0, alpha:1.0)
            cell.setSwipeGestureWith(self.viewWithImageName("check"), color: greenColor, mode: .switch, state: .state1, completionBlock: nil)
        }
    }

    fileprivate func viewWithImageName(_ imageName: String) -> UIView {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .left
        return imageView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func swipeTableViewCellDidStartSwiping(_ cell: MCSwipeTableViewCell!) {
        self.cellSwipePercentage = 0.0
    }

    func swipeTableViewCellDidEndSwiping(_ cell: MCSwipeTableViewCell!) {
        if self.cellSwipePercentage >= cell.firstTrigger {
            if let taskCell = cell as? TaskCell {
                toggleTaskDone(taskCell)
            }
        }
    }

    func swipeTableViewCell(_ cell: MCSwipeTableViewCell!, didSwipeWithPercentage percentage: CGFloat) {
        self.cellSwipePercentage = percentage
    }
}
