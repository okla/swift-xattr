###Installation###

- Add Objective-C bridging header to your project ([howto](http://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift))
- Add following lines to the bridging header:
```
#include <sys/xattr.h>
#include <string.h>
```
- Add ```ExtendedAttributes.swift``` to your project

###Usage###

```swift
import Foundation

var errorOrNames = attributesNamesAtPath("/file.txt")

if let names = errorOrNames.names {

  names.map { println($0) }
}
else {

  println(errorOrNames.error)
}

> com.apple.FinderInfo
> com.apple.metadata:_kMDItemUserTags

setAttributeWithName("custom", data: "abc".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, atPath: "/file.txt")

errorOrNames = attributesNamesAtPath("/file.txt")

if let names = errorOrNames.names {

  names.map { println($0) }
}
else {
  
  println(errorOrNames.error)
}

> com.apple.FinderInfo
> com.apple.metadata:_kMDItemUserTags
> custom

var errorOrData = dataForAttributeNamed("custom", atPath: "/file.txt")

if let data = errorOrData.data {

  println(NSString(data: data, encoding: NSUTF8StringEncoding))
}
else {
  
  println(errorOrData.error)
}

> abc

removeAttributeNamed("custom", atPath: "/file.txt")

errorOrData = dataForAttributeNamed("custom", atPath: "/file.txt")

if let data = errorOrData.data {

  println(NSString(data: data, encoding: NSUTF8StringEncoding))
}
else {

  println(errorOrData.error)
}

> Attribute not found
```

Tested with Xcode 6.3, iOS 8.1.1, OS X 10.10
