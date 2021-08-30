//
//  ListDictionary.swift
//  ListDictionary
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

public final class ListDictionary<Key: Hashable, Value: Equatable> {
    private var dictionary: [Key: [Value]] = [:]
    
    public subscript(_ key: Key) -> [Value]? {
        get {
            dictionary[key]
        }
        set {
            if let value = newValue, !value.isEmpty {
                dictionary[key] = value
            } else {
                dictionary[key] = nil
            }
        }
    }

    public func add(value: Value, forKey key: Key) {
        if var values = dictionary[key] {
            values.append(value)
            dictionary[key] = values
        } else {
            dictionary[key] = [value]
        }
    }

    public func add(values: [Value], forKey key: Key) {
        if let oldValues = dictionary[key] {
            dictionary[key] = oldValues + values
        } else {
            dictionary[key] = values
        }
    }

    public func remove(key: Key) -> Bool {
        if dictionary[key] != nil {
            dictionary[key] = nil
            return true
        } else {
            return false
        }
    }

    public func remove(value: Value, forKey key: Key) -> Bool {
        var removed = false
        if var values = dictionary[key] {
            removed = values.contains { $0 == value }
            values.removeAll{ $0 == value }

            if values.isEmpty {
                dictionary[key] = nil
            } else {
                dictionary[key] = values
            }
        }

        return removed
    }

    public func remove(values: [Value], forKey key: Key) -> [Value] {
        var removed: [Value] = []

        if var values = dictionary[key] {
            for value in values {
                let wasInList = values.contains { $0 == value }
                values.removeAll{ $0 == value }
                if wasInList {
                    removed.append(value)
                }
            }

            if values.isEmpty {
                dictionary[key] = nil
            } else {
                dictionary[key] = values
            }
        }

        return removed
    }

    public func remove(value: Value) -> [Key] {
        var removed: [Key] = []
        
        let dictionaryCopy = dictionary

        for pair in dictionaryCopy {
            var values = pair.value
            let wasInList = values.contains { $0 == value }
            values.removeAll{ $0 == value }
            if wasInList {
                removed.append(pair.key)
            }

            if values.isEmpty {
                dictionary[pair.key] = nil
            } else {
                dictionary[pair.key] = values
            }
        }
        
        return removed
    }

    public func remove(values: [Value]) -> ListDictionary<Key, Value> {
        let removed = ListDictionary<Key, Value>()

        let dictionaryCopy = dictionary
        
        for pair in dictionaryCopy {
            var newValues = pair.value

            for value in values {
                let wasInList = newValues.contains { $0 == value }
                newValues.removeAll{ $0 == value }
                if wasInList {
                    removed.add(value: value, forKey: pair.key)
                }
            }

            if newValues.isEmpty {
                dictionary[pair.key] = nil
            } else {
                dictionary[pair.key] = newValues
            }
        }

        return removed
    }

    public func enumerated() -> EnumeratedSequence<[Key: [Value]]> {
        dictionary.enumerated()
    }

    public var isEmpty: Bool {
        dictionary.isEmpty
    }

    public func keys(containing value: Value) -> [Key] {
        dictionary.filter{ pair in pair.value.contains(where: { $0 == value }) }.map(\.key)
    }

    public func contains(value: Value, forKey key: Key) -> Bool {
        return dictionary[key]?.contains{ $0 == value } ?? false
    }
}
