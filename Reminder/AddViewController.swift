import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var infoField: UITextField!
    @IBOutlet var dateTimePicker: UIDatePicker!
    
    public var ending: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        infoField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(tapSaveButton))
    }
    
    @objc func tapSaveButton () {
        if let titleText = titleField.text, !titleText.isEmpty,
           let infoText = infoField.text, !infoText.isEmpty {
            
            let selectedDate = dateTimePicker.date
            
            ending?(titleText, infoText, selectedDate)
         }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
