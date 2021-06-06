import Foundation

final class DateFormatters {
    static let ISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX'Z'"
        return formatter
    }()
    
    static let ISO8601WithoutMs: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    static let ReleaseDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension Date {
    static func fromISO8601(_ string: String) -> Date? {
        return
            DateFormatters.ISO8601.date(from: string) ??
            DateFormatters.ISO8601WithoutMs.date(from: string)
    }
}
