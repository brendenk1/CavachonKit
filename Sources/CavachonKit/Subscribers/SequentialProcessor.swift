//
//  SequentialProcessor.swift
//
//
//  Created by Brenden Konnagan on 2/24/23.
//
//  ** GNU AFFERO GENERAL PUBLIC LICENSE Version 3 **
//

import Combine
import Foundation

/// The SequentialProcessor is a subscriber that processes a single output from a publisher before requesting more to process.
public final class SequentialProcessor<T>: Subscriber {
    /// Create a new instance
    /// - Parameters:
    ///   - processor: A method to perform with the output from a publisher
    ///   - onProcessError: A method to call if the processing of input fails
    ///   - onCompletion: A method to indicate that the publisher is in the completed state
    public init(
        processor: @escaping (T) async throws -> Void,
        onProcessError: @escaping (T, Error) -> Bool,
        onCompletion: @escaping () -> Void
    )
    {
        self.onCompletion = onCompletion
        self.onProcessorError = onProcessError
        self.processor = processor
    }
    
    // MARK: - Parameters
    private let onCompletion: () -> Void
    private let onProcessorError: (T, Error) -> Bool
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
            catch {
                if self?.onProcessorError(input, error) == true {
                    self?.subscription?.request(.max(1))
                }
            }
        }
        return .none
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) { onCompletion() }
}
