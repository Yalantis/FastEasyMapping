
import Foundation
import FastEasyMapping

extension Object {

  class func defaultMapping() -> FEMMapping {
    let mapping = FEMMapping(objectClass: self)
    
    mapping.addAttributes(from: [
      #keyPath(boolValue),
      
      #keyPath(charValue),
      #keyPath(ucharValue),
      
      #keyPath(shortValue),
      #keyPath(ushortValue),
      
      #keyPath(intValue),
      #keyPath(uintValue),
      
      #keyPath(long),
      #keyPath(ulong),
      
      #keyPath(longLongValue),
      #keyPath(ulongLongValue),
      
      #keyPath(floatValue),
      #keyPath(doubleValue),
      
      // Common bridgeable types
      
      #keyPath(nsvalue),
      #keyPath(nsnumber),
      
      #keyPath(string),
      #keyPath(date),
      #keyPath(url),
      #keyPath(data),
  
      #keyPath(arrayOfStrings),
      #keyPath(setOfStrings)
    ])

    let child = FEMMapping(objectClass: ObjectChild.self)
    child.addAttributes(from: [#keyPath(string)])
    mapping.add(toManyRelationshipMapping: child, forProperty: #keyPath(children), keyPath: "children")

    return mapping
  }
}
