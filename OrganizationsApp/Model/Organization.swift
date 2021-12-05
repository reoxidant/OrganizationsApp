//
//  Organization.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import RealmSwift

class Organization: Object {
    @Persisted var name: String = ""
    @Persisted var info: String?
    @Persisted var date: Date = Date(timeIntervalSince1970: 1)
    @Persisted var employees: List<Employee>
    
    convenience init(name: String, info: String?, date: Date, employees: List<Employee> = List<Employee>()) {
        self.init()
        self.name = name
        self.info = info
        self.date = date
        self.employees = employees
    }
}
