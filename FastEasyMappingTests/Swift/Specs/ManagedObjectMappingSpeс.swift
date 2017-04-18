
import Quick
import Nimble
import FastEasyMapping
import MagicalRecord
import CoreData

class ManagedObjectMappingSpeс: QuickSpec {

  override func spec() {
    describe("mapping") {
      let mapping = ManagedObject.defaultMapping()
      var object: ManagedObject!
      
      beforeSuite {
        MagicalRecord.setLoggingLevel(.error)
        MagicalRecord.fem_setupTestsSQLiteStore()
        
        let context = NSManagedObjectContext.mr_rootSaving()
        let fixture = Fixture.build(usingFixture: "ManagedObjectSupportedTypes") as! [AnyHashable: Any]
        
        object = FEMDeserializer.object(fromRepresentation: fixture, mapping: mapping, context: context) as! ManagedObject
      }
      
      afterSuite {
        MagicalRecord.fem_cleanUp()
      }
      
      describe("non-null attributes") {
        it("should map boolValue") {
          expect(object.boolValue) == true
        }
        
        it("should map boolObject") {
          expect(object.boolObject) == true
        }
        
        it("should map malformedBoolValue") {
          expect(object.malformedBoolValue) == true
        }
        
        it("should map malformedBoolObject") {
          expect(object.malformedBoolObject) == true
        }
        
        it("should map shortValue") {
          expect(object.shortValue) == Int16.max
        }
        
        it("should map shortObject") {
           expect(object.shortObject?.int16Value) == Int16.max
        }
        
        it("should map intValue") {
          expect(object.intValue) == Int32.max
        }
        
        it("should map intObject") {
          expect(object.intObject?.int32Value) == Int32.max
        }
        
        it("should map longLongValue") {
          expect(object.longLongValue) == Int64.max
        }
        
        it("should map longLongObject") {
          expect(object.longLongObject?.int64Value) == Int64.max
        }
        
        it("should map floatValue") {
          expect(object.floatValue) == 11.1
        }
        
        it("should map floatObject") {
          expect(object.floatObject?.floatValue) == 11.1
        }
        
        it("should map doubleValue") {
          expect(object.doubleValue) == 12.2
        }
        
        it("should map doubleObject") {
          expect(object.doubleObject?.doubleValue) == 12.2
        }
        
        it("should map string") {
          expect(object.string) == "string"
        }
        
        it("should map date") {
          expect(object.date?.timeIntervalSinceReferenceDate) == 504316800.0
        }
        
        it("should map data") {
          expect(object.data) == "utf8".data(using: .utf8)
        }
        
        it("should map children") {
            expect(object.children) != nil
            expect(object.children!).to(haveCount(2))
            
            expect(object.children!.flatMap({ $0.string })).to(equal(["1", "2"]))
        }
      }
      
      describe("null attributes") {
        beforeSuite {
          let fixture = Fixture.build(usingFixture: "ManagedObjectSupportedTypesNull") as! [AnyHashable: Any]
          object = FEMDeserializer.fill(object, fromRepresentation: fixture, mapping: mapping) as! ManagedObject
        }
        
        it("should skip boolValue") {
          expect(object.boolValue) == true
        }
        
        it("should nullify boolObject") {
          expect(object.boolObject) == nil
        }
        
        it("should skip malformedBoolValue") {
          expect(object.malformedBoolValue) == true
        }
        
        it("should nullify malformedBoolObject") {
          expect(object.malformedBoolObject) == nil
        }
        
        it("should skip shortValue") {
          expect(object.shortValue) == Int16.max
        }
        
        it("should nullify shortObject") {
          expect(object.shortObject) == nil
        }
        
        it("should skip intValue") {
          expect(object.intValue) == Int32.max
        }
        
        it("should nullify intObject") {
          expect(object.intObject) == nil
        }
        
        it("should skip longLongValue") {
          expect(object.longLongValue) == Int64.max
        }
        
        it("should nullify longLongObject") {
          expect(object.longLongObject) == nil
        }
        
        it("should skip floatValue") {
          expect(object.floatValue) == 11.1
        }
        
        it("should nullify floatObject") {
          expect(object.floatObject) == nil
        }
        
        it("should skip doubleValue") {
          expect(object.doubleValue) == 12.2
        }
        
        it("should nullify doubleObject") {
          expect(object.doubleObject) == nil
        }
        
        it("should nullify string") {
          expect(object.string) == nil
        }
        
        it("should nullify date") {
          expect(object.date) == nil
        }
        
        it("should nullify data") {
          expect(object.data) == nil
        }
        
        it("should nullify children") {
          expect(object.children) == nil
        }
      }
    }
  }
}
