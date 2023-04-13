//
//  Created by Brenden Konnagan on 4/13/23.
//
//  ** GNU AFFERO GENERAL PUBLIC LICENSE Version 3 **
//

import Foundation

/// A sort comparator that can be used to sort a collection of `ListSectionItem` objects.
///
/// The sort is completed by comparing the `Key` of the item.
public struct ListSectionItemKeyComparator<Key, Element>: SortComparator
where Key: Hashable,
      Key: Comparable
{
    public init(order: SortOrder = .forward) {
        self.order = order
    }
    
    public var order: SortOrder = .forward
    
    public func compare(_ lhs: ListSectionItem<Key, Element>, _ rhs: ListSectionItem<Key, Element>) -> ComparisonResult {
        switch true {
        case lhs.key == rhs.key:    return .orderedSame
        case lhs.key < rhs.key:     return order == .forward ? .orderedAscending : .orderedDescending
        case lhs.key > rhs.key:     return order == .forward ? .orderedDescending : .orderedAscending
        default:                    return .orderedSame
        }
    }
}
