
import Foundation

// Supported objc types from
// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html

class Object: NSObject {
  // Scalar types
  
  dynamic var boolValue: Bool = false // CBool - B
  
  dynamic var charValue: Int8 = 0 // CChar c - char
  dynamic var ucharValue: UInt8 = 0 // CUnsignedChar C - unsigned char
  
  dynamic var shortValue: Int16 = 0 // CShort s - short
  dynamic var ushortValue: UInt16 = 0 // CUnsignedShort S - unsigned short
  
  dynamic var intValue: Int32 = 0 // CInt i - int
  dynamic var uintValue: UInt32 = 0 // CUnsignedInt I - int
  
  dynamic var longValue: Int = 0 // CLong l - long
  dynamic var ulongValue: UInt = 0 // CUnsignedLong L - long
  
  dynamic var longLongValue: Int64 = 0 // CLongLong q - long long
  dynamic var ulongLongValue: UInt64 = 0 // CUnsignedLongLong Q - long long
  
  dynamic var floatValue: Float = 0 // CFloat / Float f - float
  dynamic var doubleValue: Double = 0 // CFloat / Float d - float
  
  // Common bridgeable types 
  
  dynamic var nsnumberBool: NSNumber?
  
  dynamic var string: String? // NSString
  dynamic var date: Date? // NSDate
  dynamic var url: URL? // NSURL
  dynamic var data: Data? // NSData
  
  dynamic var arrayOfStrings: [String]? // NSArray
  dynamic var setOfStrings: Set<String>? // NSSet
  
  dynamic var children: Set<ObjectChild>?
}

