//
//  Employee.swift
//  OrganizationsApp
//
//  Created by Виталий Шаповалов on 03.12.2021.
//

import Foundation
import RealmSwift

class Employee: Object {
    @Persisted var name: String = ""
    @Persisted var surname: String = ""
    @Persisted var isFired: Bool = false
    
    convenience init(name: String, surname: String) {
        self.init()
        self.name = name
        self.surname = surname
    }
}
