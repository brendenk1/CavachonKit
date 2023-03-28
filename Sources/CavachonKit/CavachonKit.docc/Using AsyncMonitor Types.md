# Using AsyncMonitor Types

Objects that conform to the `AsyncMonitor` interface will allow for the interaction of `Event` types using Swift Concurrency APIs.

## Overview

Two objectives are provided by this interface: 
1. The observing of `Event` types over time
2. The monitoring for a particular `Event` and returning once received

This interface builds on top of the ``Monitor`` interface.

Default implementations are provided for the two functions outlined in the interface, giving out of the box functionality. However, they can be overridden to allow custom logic, for instance logging of the events as received by the stream.

## How to Use

Assuming a conforming type has already been created.

```
class Foo {
...
...
...
    func someWork() async {
        object.doSomething()
        // Assume monitor is connected
        await monitor.monitor(for: someEvent)
        // Work is complete
    }
}
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
