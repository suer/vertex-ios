import UIKit
import MCSwipeTableViewCell

class TaskCell: MCSwipeTableViewCell {
    let task: Task
    let row: Int
    init(task: Task, row: Int, style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.task = task
        self.row = row
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.text = task.title
        setDone(task.done)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDone(done: Bool) {
        task.done = done
        if done {
            self.accessoryType = .Checkmark
        } else {
            self.accessoryType = .None
        }
    }
}
