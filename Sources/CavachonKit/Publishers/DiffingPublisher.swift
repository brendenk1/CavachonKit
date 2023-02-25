//
//  Created by Brenden Konnagan on 2/25/23.
//
//  ** GNU AFFERO GENERAL PUBLIC LICENSE Version 3 **
//

import Combine
import Foundation

/// The DiffingPublisher will publish a set of values by subtracting a given group from another.
public struct DiffingPublisher<T>: Publisher
where T : Hashable
{
    public typealias Output = Set<T>
    public typealias Failure = Never
    
    /// Creates an instance of DiffingPublisher
    /// - Parameters:
    ///   - lhs: A collection on the left side of comparison
    ///   - rhs: A collection on the right side of comparison
    ///   - rightToLeft: Indicates if the right side should be subtracted from the left side collection
    public init(
        _ lhs: Set<T>,
        _ rhs: Set<T>,
        rightToLeft: Bool
    )
    {
        self.leftHandSide = lhs
        self.rightHandSide = rhs
        self.rightToLeft = rightToLeft
    }
    
    private let leftHandSide: Set<T>
    private let rightHandSide: Set<T>
    private let rightToLeft: Bool
    
    public func receive<S>(subscriber: S)
    where S : Subscriber,
          Never == S.Failure,
          Set<T> == S.Input
    {
        let subscription = DiffingSubscription(
            lhs: rightToLeft ? rightHandSide : leftHandSide,
            rhs: rightToLeft ? leftHandSide : rightHandSide,
            subscriber: subscriber
        )
        subscriber.receive(subscription: subscription)
    }
    
    public final class DiffingSubscription<S, T>: Subscription
    where S : Subscriber,
          S.Input == Set<T>,
          S.Failure == Never,
          T : Hashable
    {
        init(
            lhs: Set<T>,
            rhs: Set<T>,
            subscriber: S
        )
        {
            self.lhs = lhs
            self.rhs = rhs
            self.subscriber = subscriber
        }
        
        var lhs: Set<T>
        var rhs: Set<T>
        var subscriber: S?
        
        public func cancel() { subscriber = nil }
        
        public func request(_ demand: Subscribers.Demand) {
            switch demand {
            case .none:
                break
            default:
                _ = subscriber?.receive(lhs.subtracting(rhs))
            }
        }
    }
}

public extension Publisher {
    /// Allows for the diffing of a publisher that emits two sets of items.
    func diff<Element>(
        rightToLeft: Bool
    ) -> AnyPublisher<Set<Element>, Never>
    where Output == (Set<Element>, Set<Element>),
              Failure == Never,
              Element: Hashable
    {
        
        self.map { DiffingPublisher($0.0, $0.1, rightToLeft: rightToLeft) }
        .switchToLatest()
        .eraseToAnyPublisher()
    }
}
