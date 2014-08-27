import Foundation

func errnoDescription() -> String { return NSString(UTF8String: strerror(errno)) }

func setAttributeWithName(name: String, #data: NSData, toPath path: String) -> String? {
  
  if countElements(path) == 0 {
   
    return "Path can not be empty"
  }
  else if countElements(name) == 0 {
   
    return "Attribute name can not be empty"
  }
  else if setxattr(path, name, data.bytes, UInt(data.length), 0, 0) == -1 {
    
    return errnoDescription()
  }
  else {
    
    return nil
  }
}

func dataForAttributeWithName(name: String, fromPath path: String) -> (String?, NSData?) {
  
  if countElements(path) == 0 {
    
    return ("Path can not be empty", nil)
  }
  else if countElements(name) == 0 {
    
    return ("Attribute name can not be empty", nil)
  }
  else {
    
    let bufLength = getxattr(path, name, nil, 0, 0, 0)
    
    if bufLength == -1 {
      
      return (errnoDescription(), nil)
    }
    else {
      
      var buf = malloc(UInt(bufLength))
      
      if getxattr(path, name, buf, UInt(bufLength), 0, 0) == -1 {
        
        return (errnoDescription(), nil)
      }
      else {
        
        return (nil, NSData(bytes: buf, length: bufLength))
      }
    }
  }
}

func attributesNamesFromPath(path: String) -> (String?, [String]?) {
  
  if countElements(path) == 0 {
    
    return ("Path can not be empty", nil)
  }
  else {
    
    let bufLength = listxattr(path, nil, 0, 0)
    
    if bufLength == -1 {
      
      return (errnoDescription(), nil)
    }
    else {
      
      var buf = UnsafeMutablePointer<Int8>(malloc(UInt(bufLength)))
      
      if listxattr(path, buf, UInt(bufLength), 0) == -1 {
        
        return (errnoDescription(), nil)
      }
      else {
        
        var names = NSString(bytes: buf, length: bufLength, encoding: NSUTF8StringEncoding).componentsSeparatedByString("\0")
        
        names.removeLast()
        
        return (nil, (names as [String]))
      }
    }
  }
}

func removeAttributeWithName(name: String, fromPath path: String) -> String? {
  
  if countElements(path) == 0 {
    
    return "Path can not be empty"
  }
  else if countElements(name) == 0 {
    
    return "Attribute name can not be empty"
  }
  else {
    
    if removexattr(path, name, 0) == -1 {
      
      return errnoDescription()
    }
    else {
      
      return nil
    }
  }
}