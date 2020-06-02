import Foundation

struct DateFormatError: Error {
    let string: String
    let expectedFormat: String
}

public protocol CustomDateDecodable: Decodable {
    static var formatter: DateFormatter { get }
    init(date: Date)
}

extension CustomDateDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        guard let date = Self.formatter.date(from: string) else {
            throw DateFormatError(string: string, expectedFormat: Self.formatter.dateFormat)
        }
        
        self.init(date: date)
    }
}



public struct ShortDate: CustomDateDecodable {
    public init(date: Date) {
        self.date = date
    }
    
    public let date: Date
    
    public static let formatter = update(DateFormatter()) { formatter in
        formatter.dateFormat = "yyyy-MM-dd"
    }
}

public struct LongDate: CustomDateDecodable {
    public init(date: Date) {
        self.date = date
    }
    
    public static let formatter = update(DateFormatter()) { formatter in
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
    }
    
    public let date: Date

}
