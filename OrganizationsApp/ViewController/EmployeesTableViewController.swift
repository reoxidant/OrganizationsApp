//
//  EmployeesTableViewController.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import UIKit
import RealmSwift

class EmployeesTableViewController: UITableViewController {
    
    var organization: Organization?
    var notificationToken: NotificationToken?

    var isHiredEmployees: Results<Employee>?
    var isFiredEmployees: Results<Employee>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        
        isHiredEmployees = organization?.employees.where({ $0.isFired == false })
        isFiredEmployees = organization?.employees.where({ $0.isFired == true })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Hired employees"
        } else {
            return "Fired employees"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return section == 0 ? isHiredEmployees?.count ?? 0 : isFiredEmployees?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath)
        
        let employees = indexPath.section == 0 ? isHiredEmployees : isFiredEmployees
        
        guard let employee = employees?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = employee.name
        cell.detailTextLabel?.text = employee.surname
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            if let employee = self?.organization?.employees[indexPath.row] {
                StorageManager.shared.delete(object: employee)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, done in
            if let employee = self?.organization?.employees[indexPath.row] {
                self?.showAlert(employee: employee, completion: {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                })
            }
            done(true)
        }
        
        let title = indexPath.section == 0 ? "Fired" : "Hired"
        
        let firedAction = UIContextualAction(style: .normal, title: title) { [weak self] _, _, done in
            
            if let employee = indexPath.section == 0 ? self?.isHiredEmployees?[indexPath.row] : self?.isFiredEmployees?[indexPath.row] {
                StorageManager.shared.changeStatus(employee: employee)
                
                let countHiredEmployees = self?.isHiredEmployees?.count ?? 0
                let countFiredEmployees = self?.isFiredEmployees?.count ?? 0
                
                let indexPathForHiredEmployees = IndexPath(row: countHiredEmployees - 1, section: 0)
                let indexPathForFiredEmployees = IndexPath(row: countFiredEmployees - 1, section: 1)
                
                let destinationIndexPath = indexPath.section == 0 ? indexPathForFiredEmployees : indexPathForHiredEmployees
                
                tableView.moveRow(at: indexPath, to: destinationIndexPath)
            }
            done(true)
        }
        
        editAction.backgroundColor = .blue
        firedAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [firedAction, editAction, deleteAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationVC = segue.destination as? UINavigationController {
            if let addEmployeeVC = navigationVC.topViewController as? AddEmployeeViewController {
                addEmployeeVC.organization = organization
                addEmployeeVC.delegate = self
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EmployeesTableViewController {
    func showAlert(employee: Employee, completion: @escaping () -> Void) {
        
        let alertController = AlertViewController(title: "Edit employee", message: "Please insert new values", preferredStyle: .alert)
        
        alertController.editAction(employee: employee) { newName, newSurname in
            StorageManager.shared.rename(employee: employee, newValue: (newName, newSurname))
            completion()
        }
        
        present(alertController, animated: true)
    }
}

extension EmployeesTableViewController: AddEmployeeDelegate {
    func updateTable() {
        tableView.reloadData()
    }
}
