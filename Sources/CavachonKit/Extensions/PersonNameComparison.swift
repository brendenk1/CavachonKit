import Foundation

/// A object that will sort `PersonNameComponets` first by `familyName` and then `givenName`
///
/// Providing a `SortOrder` allows for the determination of order
public struct PersonNameComparison: SortComparator {
    public init(order: SortOrder) {
        self.order = order
    }

    public var order: SortOrder
    
    public func compare(
        _ lhs: PersonNameComponents,
        _ rhs: PersonNameComponents
    ) -> ComparisonResult {
        let lGiven  = lhs.givenName ?? ""
        let lFamily = lhs.familyName ?? ""
        let rGiven  = rhs.givenName ?? ""
        let rFamily = rhs.familyName ?? ""
        
        let comparison: (String, String, ((String, String) -> ComparisonResult)?) -> ComparisonResult = { lhs, rhs, tieBreak in
            switch lhs.localizedCaseInsensitiveCompare(rhs) {
            case .orderedAscending:     return .orderedAscending
            case .orderedDescending:    return .orderedDescending
            case .orderedSame:          return tieBreak?(lhs, rhs) ?? .orderedSame
            }
        }
        
        return comparison(lFamily, rFamily, { _,_ in comparison(lGiven, rGiven, nil) })
    }
}
