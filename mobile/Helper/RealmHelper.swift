//
//  RealmHelper.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation
import RealmSwift

public final class WriteTransaction {
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func add<T: Persistable>(_ value: T, update: Bool) {
        if update {
            realm.add(value.managedObject(), update: .all)
        } else {
            realm.add(value.managedObject(), update: .error)
        }
    }
    
}

// Implement the Container
public final class Container {
    private let realm: Realm
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func write(_ block: (WriteTransaction) throws -> Void)
    throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }
    
    public func get<T: Object>(_ value: T.Type){
        let data = realm.objects(T.self)
        print(data)
    }
}
