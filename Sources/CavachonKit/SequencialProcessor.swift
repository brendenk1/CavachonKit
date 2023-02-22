import Combine
import Foundation

public final class SequencialProcessor<T>: Subscriber {
    public init(
        processor: @escaping (T) async throws -> Void,
        onProcessError: @escaping (Error) -> Void,
        onCompletion: @escaping () -> Void
    )
    {
        self.onCompletion = onCompletion
        self.onProcessorError = onProcessError
        self.processor = processor
    }
    
    // MARK: - Parameters
    private let onCompletion: () -> Void
    private let onProcessorError: (Error) -> Void
    private let processor: (T) async throws -> Void
    
    // MARK: - Subscriber Conformance
    public typealias Input = T
    public typealias Failure = Never
    
    // MARK: - Properties
    private var subscription: Subscription?
    
    // MARK: - Methods
    public func receive(subscription: Subscription) {
        self.subscription = subscription
        subscription.request(.max(1))
    }
    
    public func receive(_ input: T) -> Subscribers.Demand {
        Task { [weak self] in
            do {
                try await self?.processor(input)
                self?.subscription?.request(.max(1))
            }
            catch { self?.onProcessorError(error) }
        }
        return .none
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) { onCompletion() }
}
