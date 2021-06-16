import Foundation

extension String {
    
    var asInt: Int? {
        return Int(self)
    }
    
    var asInt16: Int16? {
        return Int16(self)
    }
}

extension NSString {
    @objc func firstLetter() -> String {
        guard length > 0 else { return "" }
        return substring(to: 1)
    }
}
