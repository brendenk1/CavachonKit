import Foundation

public extension Sequence {
    /// Performs a try map on the collection, allowing for a asynchronous handler on each item
    func asyncTryMap<Result>(
        transform: (Element) async throws -> Result
    ) async throws -> [Result] {
        var mapped: [Result] = []
        for element in self {
            mapped.append(try await transform(element))
        }
        return mapped
    }
    
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
