import Foundation

func setExtendedAttributeWithName(n: String, data d: NSData, toPath p: String) -> String? {

  if setxattr(p.fileSystemRepresentation(), n.fileSystemRepresentation(), d.bytes, UInt(d.length), 0, 0) == -1 {
    
    switch errno {
      
      case ENOTSUP: return "The file system does not support extended attributes or has them disabled."
      case EROFS: return "The file system is mounted read-only."
      case ERANGE: return "The data size of the attribute is out of range (some attributes have size restrictions)."
      case EPERM: return "Attributes cannot be associated with this type of object. For example, attributes are not allowed for resource forks."
      case EINVAL: return "Name is invalid. Name must be valid UTF-8."
      case ENOTDIR: return "A component of path is not a directory."
      case ENAMETOOLONG: return "Name exceeded XATTR_MAXNAMELEN UTF-8 bytes, or a component of path exceeded NAME_MAX characters, or the entire path exceeded PATH_MAX characters."
      case EACCES: return "Search permission is denied for a component of path or permission to set the attribute is denied."
      case ELOOP: return "Too many symbolic links were encountered resolving path."
      case EFAULT: return "Path or name points to an invalid address."
      case EIO: return "An I/O error occurred while reading from or writing to the file system."
      case E2BIG: return "The data size of the extended attribute is too large."
      case ENOSPC: return "Not enough space left on the file system."
      default: return "POSIX error with code \(errno)"
    }
  }
  
  return nil
}

func getExtendedAttributeWithName(n: String, fromPath p: String) -> (String?, NSData?) {
  
  let bufferLength = getxattr(p, n, nil, 0, 0, 0)
  
  if bufferLength == -1 {
    
    switch errno {
    
      case ENOATTR: return ("The extended attribute does not exist.", nil)
      case ENOTSUP: return ("The file system does not support extended attributes or has the feature disabled.", nil)
      case EPERM, EISDIR: return ("The named attribute is not permitted for this type of object.", nil)
      case EINVAL: return ("Name is invalid. Name must be valid UTF-8.", nil)
      case ENOTDIR: return ("A component of path's prefix is not a directory.", nil)
      case ENAMETOOLONG: return ("Name exceeded XATTR_MAXNAMELEN UTF-8 bytes, or a component of path exceeded NAME_MAX characters, or the entire path exceeded PATH_MAX characters.", nil)
      case EACCES: return ("Search permission is denied for a component of path or the attribute is not allowed to be read (e.g. an ACL prohibits reading the attributes of this file).", nil)
      case ELOOP: return ("Too many symbolic links were encountered in translating the pathname.", nil)
      case EFAULT: return ("Path or name points to an invalid address.", nil)
      case EIO: return ("An I/O error occurred while reading from or writing to the file system.", nil)
      default: return ("POSIX error with code \(errno)", nil)
    }
  }
    
  var buffer = malloc(UInt(bufferLength))
    
  getxattr(p, n, buffer, UInt(bufferLength), 0, 0)
    
  return (nil, NSData(bytes: buffer, length: bufferLength))
}