
import Foundation
import CoreData


extension ManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedObject> {
        return NSFetchRequest<ManagedObject>(entityName: "ManagedObject")
    }

    @NSManaged public var boolValue: Bool
    @NSManaged public var boolObject: NSNumber?
    @NSManaged public var malformedBoolValue: Bool
    @NSManaged public var malformedBoolObject: NSNumber?
    @NSManaged public var shortValue: Int16
    @NSManaged public var shortObject: NSNumber?
    @NSManaged public var intValue: Int32
    @NSManaged public var intObject: NSNumber?
    @NSManaged public var longLongValue: Int64
    @NSManaged public var longLongObject: NSNumber?
    @NSManaged public var floatValue: Float
    @NSManaged public var floatObject: NSNumber?
    @NSManaged public var doubleValue: Double
    @NSManaged public var doubleObject: NSNumber?
    @NSManaged public var string: String?
    @NSManaged public var date: Date?
    @NSManaged public var data: Data?
    @NSManaged public var children: Set<ManagedObjectChild>?

}

// MARK: Generated accessors for children
extension ManagedObject {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: ManagedObjectChild)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: ManagedObjectChild)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}
