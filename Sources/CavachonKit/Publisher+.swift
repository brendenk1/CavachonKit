import Combine

public extension Publisher {
    func diff<Element>(
        rightToLeft: Bool = true
    ) -> AnyPublisher<Set<Element>, Never>
    where Output == (Set<Element>, Set<Element>),
              Failure == Never,
              Element: Hashable
    {
        self.map { (lhs, rhs) in
            rightToLeft ? lhs.subtracting(rhs) : rhs.subtracting(lhs)
        }
        .eraseToAnyPublisher()
    }
}
