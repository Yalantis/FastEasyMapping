// For License please refer to LICENSE file in the root of FastEasyMapping project

import Foundation

// Supported objc types from
// https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html

class Object: NSObject {
  // Scalar types
  
  @objc dynamic var boolValue: Bool = false // CBool - B
  @objc dynamic var malformedBoolValue: Bool = false // CBool - B when JSON contains 1/0 instead of true/false
  
  @objc dynamic var charValue: Int8 = 0 // CChar c - char
  @objc dynamic var ucharValue: UInt8 = 0 // CUnsignedChar C - unsigned char
  
  @objc dynamic var shortValue: Int16 = 0 // CShort s - short
  @objc dynamic var ushortValue: UInt16 = 0 // CUnsignedShort S - unsigned short
  
  @objc dynamic var intValue: Int32 = 0 // CInt i - int
  @objc dynamic var uintValue: UInt32 = 0 // CUnsignedInt I - int
  
  @objc dynamic var longValue: Int = 0 // CLong l - long
  @objc dynamic var ulongValue: UInt = 0 // CUnsignedLong L - long
  
  @objc dynamic var longLongValue: Int64 = 0 // CLongLong q - long long
  @objc dynamic var ulongLongValue: UInt64 = 0 // CUnsignedLongLong Q - long long
  
  @objc dynamic var floatValue: Float = 0 // CFloat / Float f - float
  @objc dynamic var doubleValue: Double = 0 // CFloat / Float d - float
  
  // Common bridgeable types
  
  @objc dynamic var nsnumberBool: NSNumber?
  
  @objc dynamic var string: String? // NSString
  @objc dynamic var date: Date? // NSDate
  @objc dynamic var url: URL? // NSURL
  @objc dynamic var data: Data? // NSData
  
  @objc dynamic var arrayOfStrings: [String]? // NSArray
  @objc dynamic var setOfStrings: Set<String>? // NSSet
  
  @objc dynamic var children: Set<ObjectChild>?
}

