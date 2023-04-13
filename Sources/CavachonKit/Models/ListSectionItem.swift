//
//  Created by Brenden Konnagan on 4/13/23.
//
//  ** GNU AFFERO GENERAL PUBLIC LICENSE Version 3 **
//

import Foundation

/// A object that allows for the structure of keyed values
///
/// This is a convenience object useful in SwiftUI views that allow for the iteration of them in a `ForEach`
///
/// For example:
///
/// ```
/// let groupedPeople = Dictionary(grouping: people, by: { $0.familyName.first ?? Character("") })
/// let sections = ListSectionItem.fromDictionary(groupedPeople)
///
/// ... some view ...
/// List {
///     ForEach(sections) { section in .... }
/// }
/// ```
/// A helper static method is available to create a collection of `ListSectionItem` objects from a `Dictionary`.
public struct ListSectionItem<Key, Element>: Identifiable
where Key: Hashable,
      Key: Comparable
{
    public init(key: Key, values: [Element]) {
        self.key = key
        self.values = values
    }
    
    public let key: Key
    public let values: [Element]
    
    public var id: Key { key }
    
    /// Will create a collection of `ListSectionItem` objects for each key in a given dictionary
    public static func fromDictionary(_ dictionary: [Key: [Element]]) -> [ListSectionItem] {
        dictionary.map { ListSectionItem(key: $0.key, values: $0.value) }
    }
}
