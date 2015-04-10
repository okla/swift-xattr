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

if errorOrNames.names != nil {

  for name in errorOrNames.names! {

    println(name)
  }
}
else {

  println(errorOrNames.error)
}

> com.apple.FinderInfo
> com.apple.metadata:_kMDItemUserTags

setAttributeWithName("custom", data: "abc".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, atPath: "/file.txt")

errorOrNames = attributesNamesAtPath("/file.txt")

if errorOrNames.names != nil {

  for name in errorOrNames.names! {

    println(name)
  }
}
else {
  
  println(errorOrNames.error)
}

> com.apple.FinderInfo
> custom
> com.apple.metadata:_kMDItemUserTags

var errorOrData = dataForAttributeNamed("custom", atPath: "/file.txt")

if errorOrData.data != nil {

  println(NSString(data: errorOrData.data!, encoding: NSUTF8StringEncoding))
}
else {
  
  println(errorOrData.error)
}

> abc

removeAttributeNamed("custom", atPath: "/file.txt")
    
errorOrData = dataForAttributeNamed("custom", atPath: "/file.txt")

if errorOrData.data != nil {

  println(NSString(data: errorOrData.data!, encoding: NSUTF8StringEncoding))
}
else {

  println(errorOrData.error)
}

> Attribute not found
```
Tested with Xcode 6.3 (6D570), iOS 8.1 and OSX 10.10
