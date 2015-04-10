import Foundation

/** Description of current errno value */
func errnoDescription() -> String {

  return (NSString(UTF8String: strerror(errno)) as String?) ?? "\(errno)"
}

/**
  Set extended attribute at path

  :param: name Name of extended attribute
  :param: data Data associated with extended attribute
  :param: atPath Path to file, directory, symlink etc

  :returns: error description if failed, otherwise nil
*/
func setAttributeWithName(name: String, #data: NSData, atPath path: String) -> String? {

  return setxattr(path, name, data.bytes, data.length, 0, 0) == -1 ? errnoDescription() : nil
}

/**
  Get data for extended attribute at path

  :param: name Name of extended attribute
  :param: atPath Path to file, directory, symlink etc

  :returns: Tuple with error description and attribute data. In case of success first parameter is nil, otherwise second.
*/
func dataForAttributeNamed(name: String, atPath path: String) -> (error: String?, data: NSData?) {

  let bufLength: Int = getxattr(path, name, nil, 0, 0, 0)
  
  if bufLength == -1 {

    return (errnoDescription(), nil)
  }
  else {

    var buf = malloc(bufLength)
    
    if getxattr(path, name, buf, bufLength, 0, 0) == -1 {

      return (errnoDescription(), nil)
    }
    else {

      return (nil, NSData(bytes: buf, length: bufLength))
    }
  }
}

/**
  Get names of extended attributes at path

  :param: path Path to file, directory, symlink etc

  :returns: Tuple with error description and array of extended attributes names. In case of success first parameter is nil, otherwise second.
*/
func attributesNamesAtPath(path: String) -> (error: String?, names: [String]?) {

  let bufLength: Int = listxattr(path, nil, 0, 0)
  
  if bufLength == -1 {

    return (errnoDescription(), nil)
  }
  else {

    var buf = UnsafeMutablePointer<Int8>(malloc(bufLength))
    
    if listxattr(path, buf, bufLength, 0) == -1 {

      return (errnoDescription(), nil)
    }
    else {

      if var names = NSString(bytes: buf, length: bufLength, encoding: NSUTF8StringEncoding)?.componentsSeparatedByString("\0") as? [String] {

        names.removeLast()

        return (nil, names)
      }
      else {

        return ("Unknown error", nil)
      }
    }
  }
}

/**
  Remove extended attribute at path

  :param: name Name of extended attribute
  :param: atPath Path to file, directory, symlink etc

  :returns: error description if failed, otherwise nil
*/
func removeAttributeNamed(name: String, atPath path: String) -> String? {

  return removexattr(path, name, 0) == -1 ? errnoDescription() : nil
}