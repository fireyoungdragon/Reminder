import UIKit
import UserNotifications

class ViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    var model = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func tapAdd() {
        guard let addVC = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        //let addVC = storyboard?.instantiateViewController(identifier: "add") as? AddViewController
        //show(addVC!, sender: tapAdd)
        
        addVC.title = "New Reminder"
        addVC.navigationItem.largeTitleDisplayMode = .never
        //showDetailViewController(addVC, sender: tapAdd)
        addVC.ending = { title, info, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let newConst = MyReminder(name: title, id: "id_\(title)", date: date)
                self.model.append(newConst)
                self.tableView.reloadData()
                
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = title
                notificationContent.body = info
                notificationContent.sound = .default
                
                let targetDate = date
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                let notificationRequest = UNNotificationRequest(identifier: "some id", content: notificationContent, trigger: notificationTrigger)
                UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: { error in
                    if error != nil {
                        print("some error")
                    }
                })
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    
    @IBAction func tapTest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, optionalError in
            if success {
                sheduledTest()
            } else if optionalError != nil {
                print("some error")
            }
        })
    }
}

func sheduledTest () {
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "some title"
    notificationContent.body = "some text some text some text some text some text some text"
    notificationContent.sound = .default
    
    let targetDate = Date().addingTimeInterval(10)
    let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
    let notificationRequest = UNNotificationRequest(identifier: "some id", content: notificationContent, trigger: notificationTrigger)
    UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: { error in
        if error != nil {
            print("some error")
        }
    })
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model[indexPath.row].name
        
        let date = model[indexPath.row].date
        let dateString = DateFormatter()
        dateString.dateFormat = "DD, MM, YYYY hh:mm a"
        
        cell.detailTextLabel?.text = dateString.string(from: date)
        return cell
    }
}

struct MyReminder {
    let name: String
    let id: String
    let date: Date
}


