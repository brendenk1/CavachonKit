import Combine
import Foundation

/// Objects that conform to the `AsyncMonitor` interface will allow for the interaction of `Event` types using Swift Concurrency APIs.
public protocol AsyncMonitor: Monitor {
    /// A `Publisher` of `Event` types as received
    func asyncPublisher() -> AnyPublisher<Event, Never>
    /// A `AsyncStream` of `Event` types as received
    func asyncStream() -> AsyncStream<Event>
    /// A function that allows for the monitoring of a particular event, returning once received.
    func monitor(for: Event) async
}

public extension AsyncMonitor {
    func asyncPublisher() -> AnyPublisher<Event, Never> {
        let publisher = PassthroughSubject<Event, Never>()
        
        self.handle = { publisher.send($0) }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func asyncStream() -> AsyncStream<Event> {
        AsyncStream(Event.self) { continuation in
            self.handle = { continuation.yield($0) }
        }
    }

    func monitor(for key: Event) async {
        for await event in self.asyncStream() {
            switch event == key {
            case false: continue
            case true:  return
            }
        }
    }
}
