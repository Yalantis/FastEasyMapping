// For License please refer to LICENSE file in the root of FastEasyMapping project

import Foundation
import CoreData


extension ManagedObjectChild {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedObjectChild> {
        return NSFetchRequest<ManagedObjectChild>(entityName: "ManagedObjectChild")
    }

    @NSManaged public var string: String?
  
    @NSManaged public var parent: ManagedObject?

}
