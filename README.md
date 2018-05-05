### Installation

- Add Objective-C bridging header to your project ([howto](http://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift))
- Add a line to the bridging header: ```#include <sys/xattr.h>```
- Add ```xattr.swift``` to your project

### Usage

```swift
import Foundation

do {

  let customName = "Custom"
  let customPath = "/file.txt"
  let customData = "Custom Data".data(using: .utf8)!

  // Setting an attribute
  try Xattr.set(named: customName, data: customData, atPath: customPath)

  // Getting data from an attribute
  let data = try Xattr.dataFor(named: customName, atPath: customPath)

  // Gettings list of attributes
  let names = try Xattr.names(atPath: customPath)

  // Removing an attribute
  try Xattr.remove(named: customName, atPath: customPath)
}
catch {

  print(error.localizedDescription)
}
```
