import Foundation

extension Int {
    
    var toInt16: Int16 {
        return Int16(self)
    }
    
}

extension Int16 {
    
    var toInt: Int {
        return Int(self)
    }
    
    var toNonNegativeString: String {
        if self == -1 { return "unknown" }
        
        return String(describing: self)
    }
    
}
