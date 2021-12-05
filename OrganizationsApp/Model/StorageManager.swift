//
//  StorageManager.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    let storageRealm = try? Realm()

    func save(object: Object) {
        do {
            try storageRealm?.write {
                storageRealm?.add(object)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func changeStatus(employee: Employee) {
        do {
            try storageRealm?.write {
                employee.isFired.toggle()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(object: Object) {
        do {
            try storageRealm?.write {
                storageRealm?.delete(object)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func rename(organization: Organization, newValue: String) {
        do {
            try storageRealm?.write {
                organization.name = newValue
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func rename(employee: Employee, newValue: (String, String)) {
        do {
            try storageRealm?.write {
                employee.name = newValue.0
                employee.surname = newValue.1
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(organization: Organization) {
        do {
            try storageRealm?.write {
                let employees = organization.employees
                storageRealm?.delete(employees)
                storageRealm?.delete(organization)
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func append(employee: Employee, toList: List<Employee>) {
        do {
            try storageRealm?.write {
                toList.append(employee)
            }
        } catch let error{
            print(error.localizedDescription)
        }
    }
}
