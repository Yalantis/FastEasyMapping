
import Foundation
import FastEasyMapping

extension ManagedObject {
  
  class func defaultMapping() -> FEMMapping {
    let mapping = FEMMapping(entityName: NSStringFromClass(self))
    
    mapping.addAttributes(from: [
      #keyPath(booleanValue),
      #keyPath(booleanObject),
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
      #keyPath(string),
      #keyPath(date),
      #keyPath(data)
    ])
    
    let child = FEMMapping(entityName: NSStringFromClass(ManagedObjectChild.self))
    child.addAttributes(from: [#keyPath(string)])
    
    mapping.add(toManyRelationshipMapping: child, forProperty: #keyPath(children), keyPath: "children")

    return mapping
  }
}
