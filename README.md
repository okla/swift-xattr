###Installation###

- Add Objective-C bridging header to your project ([howto](http://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift))
- Add following lines to bridging header:
```
#include <sys/xattr.h>
#include <string.h>
```
- Add ```ExtendedAttributes.swift``` to your project

###Using###

```swift
import Foundation

var (_, names) = attributesNamesFromPath("/file.txt")

for name in names! {
  
  println(name)
}

> com.apple.FinderInfo
> com.apple.metadata:_kMDItemUserTags

setAttributeWithName("Custom Attribute", data: "abc".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, toPath: "/file.txt")

(_, names) = attributesNamesFromPath("/file.txt")

for name in names! {
  
  println(name)
}

> com.apple.FinderInfo
> Custom Attribute
> com.apple.metadata:_kMDItemUserTags

var (error, data) = dataForAttributeWithName("Custom Attribute", fromPath: "/file.txt")

println(NSString(data: data!, encoding: NSUTF8StringEncoding))

> abc

removeAttributeWithName("Custom Attribute", fromPath: "/file.txt")

(error, data) = dataForAttributeWithName("Custom Attribute", fromPath: "/file.txt")

println(error!)

> Attribute not found
```
Tested with Xcode 6 beta 6, iOS 8 beta 5 and OSX 10.9.4
