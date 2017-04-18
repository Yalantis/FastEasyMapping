
import Foundation
import CoreData


extension ManagedObjectChild {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedObjectChild> {
        return NSFetchRequest<ManagedObjectChild>(entityName: "ManagedObjectChild")
    }

    @NSManaged public var parent: ManagedObject?

}
