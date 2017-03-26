//
//  Query.swift
//  snoogle
//
//  Created by Vincent Moore on 3/21/17.
//  Copyright © 2017 Vincent Moore. All rights reserved.
//
// Built based on cheatsheet: https://realm.io/news/nspredicate-cheatsheet/

import Foundation
import RealmSwift

class Query<T: Object> {
    
    private var query = ""
    private var values = [Any]()
    
    // Blanks
    func `is`() -> Query<T> {
        return self
    }
    
    func to() -> Query<T> {
        return self
    }
    
    // Supported: Int, Int8, Int16, Int32, Int64, Float, Double and NSDate
    func eql<V: Any>(_ value: V) -> Query<T> where V: Equatable {
        query += " = %@ "
        values.append(value)
        return self
    }
    
    func eqlStr(_ value: String, transform: StringTransform = .insinsitive) -> Query<T> {
        query += " ==\(transform.rawValue) %@ "
        values.append(value)
        return self
    }
    
    func gt<V: Any>(_ value: V) -> Query<T> where V: Equatable {
        query += " > %@ "
        values.append(value)
        return self
    }
    
    func lt<V: Any>(_ value: V) -> Query<T> where V: Equatable {
        query += " < %@ "
        values.append(value)
        return self
    }
    
    func lte<V: Any>(_ value: V) -> Query<T> where V: Equatable {
        query += " <= %@ "
        values.append(value)
        return self
    }
    
    func gte<V: Any>(_ value: V) -> Query<T> where V: Equatable {
        query += " >= %@ "
        values.append(value)
        return self
    }
    
    func ne<V: Any>(_ value: V) -> Query<T> where V: Equatable {
        query += " != %@ "
        values.append(value)
        return self
    }
    
    func `in`(_ collection: [Any]) -> Query<T> {
        query += " IN %@ "
        values.append(collection)
        return self
    }
    
    func key(_ key: String) -> Query<T> {
        query += " \(key) "
        return self
    }
    
    func between<V: Any>(min: V, max: V) -> Query<T> where V: Comparable {
        query += " BETWEEN {\(min), \(max)} "
        return self
    }
    
    func and() -> Query<T> {
        query += " AND "
        return self
    }
    
    func or() -> Query<T> {
        query += " OR "
        return self
    }
    
    func not() -> Query<T> {
        query += " NOT "
        return self
    }
    
    func avg() -> Query<T> {
        query += ".@avg.doubleValue "
        return self
    }
    
    func count() -> Query<T> {
        query += ".@count "
        return self
    }
    
    func min() -> Query<T> {
        query += ".@min "
        return self
    }
    
    func max() -> Query<T> {
        query += ".@max "
        return self
    }
    
    func sum() -> Query<T> {
        query += ".@sum.doubleValue "
        return self
    }
    
    func any() -> Query<T> {
        query += " ANY "
        return self
    }
    
    func some() -> Query<T> {
        query += " SOME "
        return self
    }
    
    func all() -> Query<T> {
        query += " ALL "
        return self
    }
    
    func none() -> Query<T> {
        query += " NONE "
        return self
    }
    
    func contains(_ expression: String, transform: StringTransform = .insinsitive) -> Query<T> {
        query += " CONTAINS\(transform.rawValue) %@ "
        values.append(expression)
        return self
    }
    
    func begins(with: String, transform: StringTransform = .insinsitive) -> Query<T> {
        query += " BEGINSWITH\(transform.rawValue) %@ "
        values.append(with)
        return self
    }
    
    func ends(with: String, transform: StringTransform = .insinsitive) -> Query<T> {
        query += " ENDSWITH\(transform.rawValue) %@ "
        values.append(with)
        return self
    }
    
    func like(_ expression: String, transform: StringTransform = .insinsitive) -> Query<T> {
        query += " LIKE\(transform.rawValue) %@ "
        values.append(expression)
        return self
    }
    
    func mathches(_ expression: String) -> Query<T> {
        query += " MATCHES %@ "
        values.append(expression)
        return self
    }
    
    func exec(realm: Realm) -> Results<T> {
        let predicate = NSPredicate(format: query, argumentArray: values)
        return realm.objects(T.self).filter(predicate)
    }
    
}
