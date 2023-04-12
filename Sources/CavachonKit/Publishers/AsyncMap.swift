//
//  Created by Brenden Konnagan on 4/12/23.
//
//  ** GNU AFFERO GENERAL PUBLIC LICENSE Version 3 **
//

import Combine
import Foundation

extension Publisher {
    /// Allows for an `async` transform to be applied to the stream, publishing upon completion
    public func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}
