
import Foundation
import FastEasyMapping

extension ManagedObject {
  
  class func defaultMapping() -> FEMMapping {
    let mapping = FEMMapping(entityName: NSStringFromClass(self))
    
    mapping.addAttributes(from: [
      #keyPath(boolValue),
      #keyPath(boolObject),
      #keyPath(malformedBoolValue),
      #keyPath(malformedBoolObject),
      #keyPath(shortValue),
      #keyPath(shortObject),
      #keyPath(intValue),
      #keyPath(intObject),
      #keyPath(longLongValue),
      #keyPath(longLongObject),
      #keyPath(floatValue),
      #keyPath(floatObject),
      #keyPath(doubleValue),
      #keyPath(doubleObject),
      #keyPath(string)
    ])
    
    mapping.addAttribute(FEMAttribute.mapping(ofProperty: #keyPath(date), toKeyPath: "date", dateFormat: "YYYY"))
    mapping.addAttribute(FEMAttribute.stringToDataMapping(of: #keyPath(data), keyPath: "data"))
    
    let child = FEMMapping(entityName: NSStringFromClass(ManagedObjectChild.self))
    child.addAttributes(from: [#keyPath(string)])
    
    mapping.add(toManyRelationshipMapping: child, forProperty: #keyPath(children), keyPath: "children")

    return mapping
  }
}
