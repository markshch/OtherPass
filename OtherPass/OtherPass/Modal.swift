//
//  Modal.swift
//  TestApp
//
//  Created by Mark ⠀ on 3/25/22.
//

import SwiftUI
import RealmSwift

final class Modal: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String = "New Pass"
    @Persisted var legend: String = ""
    @Persisted var barcodeText: String = ""
//    @Persisted var barcodeType: String = "-100"
    @objc private dynamic var _name = "33"
    
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
}

final class Group: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Group. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The collection of Items in this group.
    @Persisted var items = RealmSwift.List<Modal>()
}
