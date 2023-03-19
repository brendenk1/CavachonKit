import Foundation

public extension Bool {
    /// Returns an `Int` value based on self
    ///
    /// If self is `true` then value of `1` is returned
    /// If self is `false` then value of `0` is returned
    var intValue: Int {
        self ? 1 : 0
    }
}
