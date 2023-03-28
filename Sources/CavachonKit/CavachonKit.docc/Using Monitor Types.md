# Using Monitor Types

Objects that conform to the `Monitor` interface will allow for the interaction of `Event` types via it's `handle` property.

## Overview

Delegates are a common pattern found in APIs that we wish to consume. The ``Monitor`` interface provides a common API that delegate objects can conform to in order to process events as received. 

## How to Use

1. Create a monitor object that will be used as a delegate.
```
final class FooMonitor: Monitor {
    var handle: (Event) -> Void

    // Some Delegate Method
    func onCallback(...) {
        ...
        handle(SomeEvent)
    }
}
```

2. Use monitor
```
class Foo {
...
...
...
    func setupDelegate() {
        let monitor = FooMonitor { event in
            // Handle centralized event here...
        }
    }
}
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
