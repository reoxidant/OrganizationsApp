//
//  AlertViewController.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 04.12.2021.
//

import UIKit

class AlertViewController: UIAlertController {

    func editAction(organization: Organization, completion: @escaping (String) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text, !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "New organization name"
            textField.text = organization.name
        }
    }
    
    func editAction(employee: Employee, completion: @escaping (String, String) -> Void) {
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newName = self.textFields?.first?.text, !newName.isEmpty else { return }
            guard let newSurname = self.textFields?.last?.text, !newSurname.isEmpty else { return }
            completion(newName, newSurname)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        
        addTextField { textField in
            textField.placeholder = "New name:"
            textField.text = employee.name
        }
        
        addTextField { textField in
            textField.placeholder = "New surname:"
            textField.text = employee.surname
        }
    }
}
