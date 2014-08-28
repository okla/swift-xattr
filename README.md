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

if let attributesNames = attributesNamesAtPath("/file.txt").names {
  
  for name in attributesNames {
    
    println(name)
  }
}

> com.apple.FinderInfo
> com.apple.metadata:_kMDItemUserTags

setAttributeWithName("Custom", data: "abc".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, atPath: "/file.txt")

if let attributesNames = attributesNamesAtPath("/file.txt").names {
  
  for name in attributesNames {
    
    println(name)
  }
}

> com.apple.FinderInfo
> Custom
> com.apple.metadata:_kMDItemUserTags

if let attributeData = dataForAttributeNamed("Custom", atPath: "/file.txt").data {
  
  println(NSString(data: attributeData, encoding: NSUTF8StringEncoding))
}

> abc

removeAttributeNamed("Custom", atPath: "/file.txt")

if let error = dataForAttributeNamed("Custom", atPath: "/file.txt").error {
  
  println(error)
}

> Attribute not found
```
Tested with Xcode 6 beta 6, iOS 8 beta 5 and OSX 10.9.4
