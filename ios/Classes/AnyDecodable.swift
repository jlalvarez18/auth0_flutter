//
//  AnyDecodable.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation

public struct AnyDecodable: Decodable {
    public let value: Any
    
    public init<T>(value: T?) {
        self.value = value ?? ()
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.init(value: NSNull())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(value: bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(value: int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(value: uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(value: double)
        } else if let string = try? container.decode(String.self) {
            self.init(value: string)
        } else if let float = try? container.decode(Float.self) {
            self.init(value: float)
        } else if let array = try? container.decode([AnyDecodable].self) {
            self.init(value: array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
            self.init(value: dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
}

extension AnyDecodable: Equatable {
    
    public static func == (lhs: AnyDecodable, rhs: AnyDecodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (NSNull, NSNull), is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: AnyDecodable], rhs as [String: AnyDecodable]):
            return lhs == rhs
        case let (lhs as [AnyDecodable], rhs as [AnyDecodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension AnyDecodable: CustomStringConvertible {
    
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AnyDecodable: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyDecodable(\(value.debugDescription))"
        default:
            return "AnyDecodable(\(description))"
        }
    }
}
