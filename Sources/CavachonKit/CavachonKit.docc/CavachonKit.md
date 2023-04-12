# ``CavachonKit``

CavachonKit is a small set of commonly used tools for various projects.

## Overview

Over time, various projects and circumstances have found me finding common patterns for which I engineer solutions. CavachonKit serves as a repository of standard practices I use.

### Extensions

- A property on Bool types is provided that converts a `Bool` to `Int`.

- A function on Sequence types is provided `asyncReduce(_ : :)` that performs a `reduce` with an asynchronous handler.

- A function on Optional types that allows for the throwing unwrapping of a value.

- A function on Publisher types that allows for `async` transforms to be applied to the stream.

## Topics

### Comparators

- ``PersonNameComparison``

### Protocols

- <doc:Using-AsyncMonitor-Types>
- ``AsyncMonitor``

- <doc:Using-Monitor-Types>
- ``Monitor``

### Publishers

- <doc:Using-DiffingPublisher>
- ``DiffingPublisher``

### Subscribers

- <doc:Using-SequentialProcessor>
- ``SequentialProcessor``
