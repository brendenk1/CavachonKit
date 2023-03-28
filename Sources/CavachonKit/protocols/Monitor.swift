import Foundation

/// Objects that conform to the `Monitor` interface will allow for the interaction of `Event` types via it's `handle` property.
public protocol Monitor: AnyObject {
    associatedtype Event where Event : Equatable

    /// A property that allows for storing a function to act on an `Event`
    var handle: (Event) -> Void { get set }
}
