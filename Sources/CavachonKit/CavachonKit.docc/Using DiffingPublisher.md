# Using DiffingPublisher

The DiffingPublisher will publish a set of values by subtracting a given group from another.

## Overview

The DiffingPublisher requires three parameters to create an instance, a collection to form the "left-hand side," a group to form the "right-hand side," and a flag to indicate if the comparison should be made "right to left."

The publisher uses "set" logic to determine the two collections' differences. When the flag is "right to left," the collection on the right-hand side is subtracted from the left-hand side and vice-versa.
![A flow showing how the DiffingPublisher works](DiffingPublisher.png)

For convienience a method on Publisher, `diff(rightToLeft: )` is provided to allow for chaining of the DiffingPublisher.

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
