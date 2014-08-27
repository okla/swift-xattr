import Foundation

func errnoDescription() -> String {
  
  switch errno {
      
    case ENOENT: return "No such file or directory"
    case ENOTSUP: return "The file system does not support extended attributes or has them disabled."
    case EROFS: return "The file system is mounted read-only."
    case ERANGE: return "The data size of the attribute is out of range (some attributes have size restrictions)."
    case EINVAL: return "Name is invalid. Name must be valid UTF-8."
    case ENOTDIR: return "A component of path is not a directory."
    case ENAMETOOLONG: return "Name exceeded XATTR_MAXNAMELEN UTF-8 bytes, or a component of path exceeded NAME_MAX characters, or the entire path exceeded PATH_MAX characters."
    case EACCES: return "Search permission is denied for a component of path or permission to set the attribute is denied."
    case ELOOP: return "Too many symbolic links were encountered resolving path."
    case EFAULT: return "Path or name points to an invalid address."
    case EIO: return "An I/O error occurred while reading from or writing to the file system."
    case E2BIG: return "The data size of the extended attribute is too large."
    case ENOSPC: return "Not enough space left on the file system."
    case ENOATTR: return "The extended attribute does not exist."
    case EPERM, EISDIR: return "The named attribute is not permitted for this type of object."
    default: return "Error \(errno)"
  }
}

func setExtendedAttributeWithName(n: String, data d: NSData, toPath p: String) -> String? {
  
  if countElements(p) == 0 {
   
    return "Path can not be empty"
  }
  else if countElements(n) == 0 {
   
    return "Attribute name can not be empty"
  }
  else if setxattr(p.fileSystemRepresentation(), n.fileSystemRepresentation(), d.bytes, UInt(d.length), 0, 0) == -1 {
    
    return errnoDescription()
  }
  else {
    
    return nil
  }
}

func getExtendedAttributeWithName(n: String, fromPath p: String) -> (String?, NSData?) {
  
  if countElements(p) == 0 {
    
    return ("Path can not be empty", nil)
  }
  else if countElements(n) == 0 {
    
    return ("Attribute name can not be empty", nil)
  }
  else {
    
    let bufferLength = getxattr(p, n, nil, 0, 0, 0)
    
    if bufferLength == -1 {
      
      return (errnoDescription(), nil)
    }
    else {
      
      var buffer = malloc(UInt(bufferLength))
      
      if getxattr(p, n, buffer, UInt(bufferLength), 0, 0) == -1 {
        
        return (errnoDescription(), nil)
      }
      else {
        
        return (nil, NSData(bytes: buffer, length: bufferLength))
      }
    }
  }
}