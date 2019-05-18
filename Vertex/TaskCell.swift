import UIKit
import MCSwipeTableViewCell

class TaskCell: MCSwipeTableViewCell {
    let task: Task
    let row: Int
    init(task: Task, row: Int, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.task = task
        self.row = row
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.text = task.title
        setDone(task.done)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDone(_ done: Bool) {
        task.done = done
        if done {
            self.accessoryType = .checkmark
            self.backgroundColor = UIColor(white: 242.0 / 255.0, alpha: 1.0)
        } else {
            self.accessoryType = .none
            self.backgroundColor = UIColor.white
        }
    }
}
