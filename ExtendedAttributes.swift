import Foundation

/**
  Description of current errno state

  :returns: Error description
*/
func errnoDescription() -> String { return NSString(UTF8String: strerror(errno)) }

/**
  Set value for extended attribute

  :param: name Name of extended attribute
  :param: data Value for extended attribute
  :param: toPath Path to file, directory, symlink etc

  :returns: In case of success return nil, in case of fail return error description
*/
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

/**
  Get value for extended attribute

  :param: name Name of extended attribute
  :param: fromPath Path to file, directory, symlink etc

  :returns: Tuple with two parameters. In case of success first parameter is nil, second is extended attribute value. In case of fail first parameter is error description, second is nil.
*/
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

/**
  Get names of extended attributes associated with path

  :param: path Path to file, directory, symlink etc

  :returns: Tuple with two parameters. In case of success first parameter is nil, second is extended attributes names. In case of fail first parameter is error description, second is nil.
*/
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

/**
  Remove extended attribute

  :param: name Name of extended attribute
  :param: fromPath Path to file, directory, symlink etc

  :returns: In case of success return nil, in case of fail return error description
*/
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