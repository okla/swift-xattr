###Installation###

- Add Objective-C bridging header to your project, described [here](http://stackoverflow.com/questions/24002369/how-to-call-objective-c-code-from-swift)
- Add strings to bridging header:
```
#include <sys/xattr.h>
#include <string.h>
```
- Add ```ExtendedAttributes.swift``` to your project
