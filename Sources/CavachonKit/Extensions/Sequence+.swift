import Foundation

public extension Sequence {
    /// Performs a `reduce` on the collection, allowing for a asynchronous handler on each item
    func asyncReduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: ((Result, Element) async -> Result)
    ) async -> Result {
        var result = initialResult
        for element in self {
            result = await nextPartialResult(result, element)
        }
        return result
    }
}
