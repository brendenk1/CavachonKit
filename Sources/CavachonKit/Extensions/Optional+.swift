//
//  Created by Brenden Konnagan on 4/12/23.
//
//  ** GNU AFFERO GENERAL PUBLIC LICENSE Version 3 **
//

import Foundation

extension Optional {
    public enum OptionalError: Error {
        case nilValue
    }
    
    public func tryUnwrap() throws -> Wrapped {
        switch self {
        case .none: throw OptionalError.nilValue
        case .some(let wrapped): return wrapped
        }
    }
}
