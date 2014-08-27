swift-xattr
===========

iOS/OSX Swift language wrappers for Extended File Attributes handling functions setxattr, getxattr, listxattr and removexattr


Installation
============

- Add Objective-C bridging header to your project. Described [here on SO](http://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift)
- Add #include <sys/xattr.h> and #include <string.h> string to bridging header
- Add ExtendedAttributes.swift to your project
