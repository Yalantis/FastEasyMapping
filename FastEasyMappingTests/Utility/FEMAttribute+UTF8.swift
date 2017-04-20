// For License please refer to LICENSE file in the root of FastEasyMapping project

import Foundation
import FastEasyMapping

extension FEMAttribute {

  class func stringToDataMapping(of property: String, keyPath: String?) -> FEMAttribute {
    return FEMAttribute(property: property, keyPath: keyPath, map: { value -> Any? in
      return (value as? String)?.data(using: .utf8)
    }, reverseMap: { value -> String? in
      if let value = value as? Data {
        return String(data: value, encoding: .utf8)
      } else {
        return nil
      }
    })
  }
}
