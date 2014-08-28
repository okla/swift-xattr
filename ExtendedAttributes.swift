import Foundation

/**
  Description of current errno state

  :returns: Error description
*/
func errnoDescription() -> String {
  return NSString(UTF8String: strerror(errno))
}

/**
  Set extended attribute at path

  :param: name Name of extended attribute
  :param: data Data for extended attribute
  :param: atPath Path to file, directory, symlink etc

  :returns: In case of success return nil, in case of fail return error description
*/
func setAttributeWithName(name: String, #data: NSData, atPath path: String) -> String? {
  return setxattr(path, name, data.bytes, UInt(data.length), 0, 0) == -1 ? errnoDescription() : nil
}

/**
  Get data for extended attribute at path

  :param: name Name of extended attribute
  :param: atPath Path to file, directory, symlink etc

  :returns: Tuple with error description and attribute data. In case of success first parameter is nil, in case of fail second.
*/
func dataForAttributeNamed(name: String, atPath path: String) -> (error: String?, data: NSData?) {
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

/**
  Get names of extended attributes at path

  :param: path Path to file, directory, symlink etc

  :returns: Tuple with error description and array of extended attributes names. In case of success first parameter is nil, in case of fail second.
*/
func attributesNamesAtPath(path: String) -> (error: String?, names: [String]?) {
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

/**
  Remove extended attribute at path

  :param: name Name of extended attribute
  :param: atPath Path to file, directory, symlink etc

  :returns: In case of success return nil, in case of fail return error description
*/
func removeAttributeNamed(name: String, atPath path: String) -> String? {
  return removexattr(path, name, 0) == -1 ? errnoDescription() : nil
}