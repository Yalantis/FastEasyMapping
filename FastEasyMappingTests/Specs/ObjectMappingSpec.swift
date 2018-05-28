// For License please refer to LICENSE file in the root of FastEasyMapping project

import Quick
import Nimble
import FastEasyMapping

class ObjectMappingSpeс: QuickSpec {
  
  override func spec() {
    describe("mapping") {
      var object: Object!
      let mapping = Object.defaultMapping()
      
      beforeEach {
        let fixture = Fixture.build(usingFixture: "ObjectSupportedTypes") as! [AnyHashable: Any]
        object = FEMDeserializer.object(fromRepresentation: fixture, mapping: mapping) as! Object
      }
      
      describe("non-null attributes") {
        it("should map boolValue") {
          expect(object.boolValue) == true
        }
        
        it("should map malformedBoolValue") {
          expect(object.malformedBoolValue) == true
        }
        
        it("should map charValue") {
          expect(object.charValue) == Int8.max
        }
        
        it("should map ucharValue") {
          expect(object.ucharValue) == UInt8.max
        }
        
        it("should map shortValue") {
          expect(object.shortValue) == Int16.max
        }
        
        it("should map ushortObject") {
          expect(object.ushortValue) == UInt16.max
        }
        
        it("should map intValue") {
          expect(object.intValue) == Int32.max
        }
        
        it("should map uintValue") {
          expect(object.uintValue) == UInt32.max
        }
        
        it("should map longValue") {
          expect(object.longValue) == Int(Int32.max) // JSON contains 32-bits long
        }
        
        it("should map ulongValue") {
          expect(object.ulongValue) == UInt(UInt32.max) // JSON contains 32-bits long
        }
        
        it("should map longLongValue") {
          expect(object.longLongValue) == Int64.max
        }
        
        it("should map ulongLongValue") {
          expect(object.ulongLongValue) == UInt64.max
        }
        
        it("should map floatValue") {
          expect(object.floatValue) == 11.1
        }
        
        it("should map doubleValue") {
          expect(object.doubleValue) == 12.2
        }
        
        it("should map nsnumberBool") {
          expect(object.nsnumberBool) == true
        }

        it("should map string") {
          expect(object.string) == "string"
        }
        
        it("should map date") {
          expect(object.date?.timeIntervalSinceReferenceDate) == 504316800.0
        }

        it("should map url") {
          expect(object.url) == URL(string: "https://google.com")
        }
        
        it("should map data") {
          expect(object.data) == "utf8".data(using: .utf8)
        }
        
        it("should map arrayOfStrings") {
          expect(object.arrayOfStrings) == ["1", "2"]
        }
        
        it("should map arrayOfStrings") {
          expect(object.setOfStrings) == ["1", "2"]
        }

        it("should map children") {
          expect(object.children).toNot(beNil())
          expect(object.children!).to(haveCount(2))
          
          expect(object.children!.flatMap({ $0.string })).to(contain(["1", "2"]))
        }
      }
      
      describe("null attributes") {
        beforeEach {
          let fixture = Fixture.build(usingFixture: "ObjectSupportedTypesNull") as! [AnyHashable: Any]
          object = FEMDeserializer.fill(object, fromRepresentation: fixture, mapping: mapping) as! Object
        }
        
        it("should skip boolValue") {
          expect(object.boolValue) == true
        }
        
        it("should skip malformedBoolValue") {
          expect(object.malformedBoolValue) == true
        }
        
        it("should skip charValue") {
          expect(object.charValue) == Int8.max
        }
        
        it("should skip ucharValue") {
          expect(object.ucharValue) == UInt8.max
        }
        
        it("should skip shortValue") {
          expect(object.shortValue) == Int16.max
        }
        
        it("should skip ushortObject") {
          expect(object.ushortValue) == UInt16.max
        }
        
        it("should skip intValue") {
          expect(object.intValue) == Int32.max
        }
        
        it("should skip uintValue") {
          expect(object.uintValue) == UInt32.max
        }
        
        it("should skip longValue") {
          expect(object.longValue) == Int(Int32.max) // JSON contains 32-bits long
        }
        
        it("should skip ulongValue") {
          expect(object.ulongValue) == UInt(UInt32.max) // JSON contains 32-bits long
        }
        
        it("should skip longLongValue") {
          expect(object.longLongValue) == Int64.max
        }
        
        it("should skip ulongLongValue") {
          expect(object.ulongLongValue) == UInt64.max
        }
        
        it("should skip floatValue") {
          expect(object.floatValue) == 11.1
        }
        
        it("should skip doubleValue") {
          expect(object.doubleValue) == 12.2
        }
        
        it("should nullify nsnumberBool") {
          expect(object.nsnumberBool).to(beNil())
        }
        
        it("should nullify string") {
          expect(object.string).to(beNil())
        }
        
        it("should nullify date") {
          expect(object.date).to(beNil())
        }
        
        it("should nullify url") {
          expect(object.url).to(beNil())
        }
        
        it("should nullify data") {
          expect(object.data).to(beNil())
        }
        
        it("should nullify arrayOfStrings") {
          expect(object.arrayOfStrings).to(beNil())
        }
        
        it("should nullify arrayOfStrings") {
          expect(object.setOfStrings).to(beNil())
        }
        
        it("should nullify children") {
          expect(object.children).to(beNil())
        }
      }
    }
  }
}
