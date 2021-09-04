//
//  SequenceExtensions.swift
//  SequenceExtensions
//
//  Created by Wilhelm Oks on 26.08.21.
//

import Foundation

extension Sequence where Element: Hashable {
    /// Returns elements without duplicates in linear complexity O(n).
    /// Equality of elements is determined by the `Hashable` protocol.
    /// The order of elements is preserved.
    func uniqueElements() -> [Element] {
        var unique = Set<Element>()
        return filter { element in
            return unique.insert(element).inserted
        }
    }
}

public extension Sequence where Element: AdditiveArithmetic {
    /// Returns the arithmetic sum of all the elements in the sequence.
    /// Returns 0 if the sequence is empty.
    func sum() -> Element {
        reduce(.zero, +)
    }
}

public extension Sequence {   
    func sorted<T: Comparable>(by transform: (Element) -> T) -> [Element] {
        return sorted { lhs, rhs in
            return transform(lhs) < transform(rhs)
        }
    }
    
    func sortedDescending<T: Comparable>(by transform: (Element) -> T) -> [Element] {
        return sorted { lhs, rhs in
            return transform(lhs) > transform(rhs)
        }
    }
}

public extension Sequence {
    func min<T: Comparable>(by transform: (Element) -> T) -> Element? {
        return self.min { lhs, rhs in
            return transform(lhs) < transform(rhs)
        }
    }
    
    func max<T: Comparable>(by transform: (Element) -> T) -> Element? {
        return self.max { lhs, rhs in
            return transform(lhs) < transform(rhs)
        }
    }
}
