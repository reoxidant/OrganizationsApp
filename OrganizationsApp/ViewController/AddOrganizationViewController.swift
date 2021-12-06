//
//  AddOrganizationViewController.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import UIKit
import RealmSwift

class AddOrganizationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var infoLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.delegate = self
        nameLabel.delegate = self
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let name = nameLabel.text ?? ""
        let info = infoLabel.text
        
        let organization = Organization(name: name, info: info, date: datePicker.date)
        
        StorageManager.shared.save(object: organization)
        
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension AddOrganizationViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
