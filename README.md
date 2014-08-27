swift-xattr
===========

iOS/OSX Swift language wrappers for Extended File Attributes handling functions setxattr, getxattr, listxattr and removexattr


Installation
============

- Add Objective-C bridging header to your project. Described [here](http://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift).
- Add strings to your bridging header:
```
#include <sys/xattr.h>
#include <string.h>
```
- Add ```ExtendedAttributes.swift``` to your project
