// For License please refer to LICENSE file in the root of FastEasyMapping project

import Foundation
import FastEasyMapping

extension Object {

  class func defaultMapping() -> FEMMapping {
    let mapping = FEMMapping(objectClass: self)
    
    mapping.addAttributes(from: [
      #keyPath(boolValue),
      #keyPath(malformedBoolValue),

      #keyPath(charValue),
      #keyPath(ucharValue),
      
      #keyPath(shortValue),
      #keyPath(ushortValue),
      
      #keyPath(intValue),
      #keyPath(uintValue),
      
      #keyPath(longValue),
      #keyPath(ulongValue),
      
      #keyPath(longLongValue),
      #keyPath(ulongLongValue),
      
      #keyPath(floatValue),
      #keyPath(doubleValue),
      
      // Common bridgeable types
    
      #keyPath(nsnumberBool),
      
      #keyPath(string),
  
      #keyPath(arrayOfStrings),
      #keyPath(setOfStrings)
    ])
    
    mapping.addAttribute(FEMAttribute.mapping(ofURLProperty: #keyPath(url), toKeyPath: "url"))
    mapping.addAttribute(FEMAttribute.mapping(ofProperty: #keyPath(date), toKeyPath: "date", dateFormat: "YYYY"))
    mapping.addAttribute(FEMAttribute.stringToDataMapping(of: #keyPath(data), keyPath: "data"))
    
    let child = FEMMapping(objectClass: ObjectChild.self)
    child.addAttributes(from: [#keyPath(string)])
    mapping.add(toManyRelationshipMapping: child, forProperty: #keyPath(children), keyPath: "children")

    return mapping
  }
}
