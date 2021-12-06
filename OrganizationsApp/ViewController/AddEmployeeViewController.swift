//
//  AddEmployeeViewController.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import UIKit
import RealmSwift

protocol AddEmployeeDelegate: AnyObject {
    func updateTable()
}

class AddEmployeeViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!

    var organization: Organization?
    weak var delegate: AddEmployeeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        nameField.delegate = self
        surnameField.delegate = self
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let surname = surnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard let organization = organization, !name.isEmpty, !surname.isEmpty else {
            
            let alert = UIAlertController(title: "Ooops!!!", message: "Please enter text to save employee", preferredStyle: .alert)
                        
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let employee = Employee(name: name, surname: surname)
        StorageManager.shared.append(employee: employee, toList: organization.employees)
        delegate?.updateTable()
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddEmployeeViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
