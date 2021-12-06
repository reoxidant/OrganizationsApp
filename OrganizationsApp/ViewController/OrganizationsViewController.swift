//
//  OrganizationsViewController.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import UIKit
import RealmSwift

class OrganizationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var organizations: Results<Organization>?
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = editButtonItem
        organizations = StorageManager.shared.storageRealm?.objects(Organization.self).sorted(byKeyPath: "name")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notificationToken = organizations?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)} ), with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                }, completion: { finished in
                    print("tableView is updated")
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationToken?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        if let employeesTableVC = segue.destination as? EmployeesTableViewController {
            employeesTableVC.organization = organizations?[indexPath.row]
        }
    }
    
    @IBAction func sortOrganization(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            organizations = organizations?.sorted(byKeyPath: "name", ascending: true)
        } else {
            organizations = organizations?.sorted(byKeyPath: "date", ascending: false)
        }
        
        tableView.reloadData()
    }
}


extension OrganizationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "organizationCell", for: indexPath)
        
        guard let organization = organizations?[indexPath.row] else { return cell }
        
        cell.textLabel?.text = organization.name
        cell.detailTextLabel?.text = "Employees: \(organization.employees.count)"
        
        return cell
    }
    
}

extension OrganizationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete, let organization = organizations?[indexPath.row] {
//            StorageManager.shared.delete(organization: organization)
//        }
//    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            if let organization = self?.organizations?[indexPath.row] {
                StorageManager.shared.delete(organization: organization)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, done in
            if let organization = self?.organizations?[indexPath.row] {
                self?.showAlert(organization: organization)
            }
            done(true)
        }
        
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
}

extension OrganizationsViewController {
    func showAlert(organization: Organization) {
        let alertController = AlertViewController(title: "Edit organization", message: "Please insert new value", preferredStyle: .alert)
        
        alertController.editAction(organization: organization) { newName in
            StorageManager.shared.rename(organization: organization, newValue: newName)
        }
        
        present(alertController, animated: true)
    }
}
