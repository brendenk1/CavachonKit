# Using SequentialProcessor

The SequentialProcessor is a subscriber that processes a single output from a publisher before requesting more to process.

## Overview

The SequentialProcessor utilizes backpressure only to accept a single item at a time. The SequentialProcessor instance will ask for the following item when processing the first item is complete.
![A flow showing how the SequentialProcessor works](SequentialProcessor.png)

The SequentialProcess itself has no buffer. While the processor is busy, the publisher discards subsequent output. Depending on circumstances, a buffer or another subscriber can be utlized to capture output to action at another time.

### Create an Instance

```
let subscriber = SequentialProcessor<Int> { number in
    // Do some work with the number
} onProcessError: { number, error in
    // Do something with the number and error, 
    // return if the subscriber should request the next item or stop
} onCompletion: {
    // Do something when the publisher has gone cold
}
```

### Attach to Publisher

```
[1, 2, 3]
    .publisher
    .subscribe(subscriber)
```
