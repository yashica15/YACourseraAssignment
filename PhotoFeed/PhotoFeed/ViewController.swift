//
//  ViewController.swift
//  PhotoFeed
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var updateButton: UIButton!
    
    let kLastUpdatedAt = "buttonTapped"
    let kFullName = "textFullName"
    let kDateOfBirth = "textDateOfBirth"
    let kEmail = "textEmail"
    let kAddress = "textAddress"

    var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateDataLabels()
        self.viewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height
        + 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addBackgrounTouchForEndEditing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeBackgroundTouchGesture()
    }

    func viewProperties() {
        self.txtFirstname.addBorder()
        self.txtLastname.addBorder()
        self.txtDateOfBirth.addBorder()
        self.txtEmail.addBorder()
        self.txtAddress.addBorder()
        
        self.setDatePickerProperties()
    }
    
    func setDatePickerProperties() -> Void {
        self.datePicker.isHidden = true
        self.datePicker.maximumDate = Date()
        self.txtDateOfBirth.delegate = self
        //self.txt3.inputView = picker // don't do this
        self.txtDateOfBirth.inputView = self.datePicker // do like this.
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButton))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButton))
        
        //ToolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.txtDateOfBirth.inputAccessoryView = toolBar
    }
    
    @objc func doneButton(){
        let selectedDate  = datePicker.date
        print(selectedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        self.txtDateOfBirth.text = dateFormatter.string(from: selectedDate)
        self.txtDateOfBirth.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTextData() {
        if let firstName = self.txtFirstname.text, let lastName = self.txtLastname.text {
            let fullName = firstName + " " + lastName
            UserDefaults.standard.set(fullName, forKey: kFullName)
        }
        
        if let dob = self.txtDateOfBirth.text {
            UserDefaults.standard.set(dob, forKey: kDateOfBirth)
        }
        
        if let email = self.txtEmail.text {
            UserDefaults.standard.set(email, forKey: kEmail)
        }
        
        if let address = self.txtAddress.text {
            UserDefaults.standard.set(address, forKey: kAddress)
        }
        
        let now = NSDate()
        UserDefaults.standard.set(now, forKey: kLastUpdatedAt)
        
    }

    func updateDataLabels () {
        if let fullname = UserDefaults.standard.object(forKey: kFullName) as? String {
            self.fullNameLabel.text = "Fullname: " + fullname
        }
        
        if let dob = UserDefaults.standard.object(forKey: kDateOfBirth) as? String {
            self.dateOfBirthLabel.text = "Date Of Birth: " + dob
        }
        
        if let email = UserDefaults.standard.object(forKey: kEmail) as? String {
            self.emailLabel.text = "Email: " + email
        }

        if let address = UserDefaults.standard.object(forKey: kAddress) as? String {
            self.addressLabel.text = "Address: " + address
        }

        if let lastUpdate: NSDate = UserDefaults.standard.object(forKey: kLastUpdatedAt) as? NSDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            self.dateLabel.text = "Last Updated: " + dateFormatter.string(from: lastUpdate as Date)
        } else {
            self.dateLabel.text = "No date saved."
        }
    }
    
    @IBAction func updateButtonAction(sender: AnyObject) {
        self.updateTextData()
        self.updateDataLabels()
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtDateOfBirth {
            self.datePicker.isHidden = false
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func addBackgrounTouchForEndEditing() {
        self.tapGesture.addTarget(self, action: #selector(self.removeTextFieldResponder))
        self.tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    // remove background touch gesture
    func removeBackgroundTouchGesture() {
        self.view.removeGestureRecognizer(self.tapGesture);
    }
    
    // remove text field responder
    @objc func removeTextFieldResponder() {
        self.view.endEditing(true)
    }
}

extension UIView {
    func addBorder(cornerRadius: CGFloat = 5, borderColor: UIColor = .lightGray, borderWidth: CGFloat = 1.0) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}
