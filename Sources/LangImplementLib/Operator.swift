//
//  Operator.swift
//  LangImplementLib
//
//  Created by PondokIOS on 19/07/19.
//

import Foundation

public enum Operator: String, RawRepresentable {
    case plus = #"\+|plus"#
    case minus = #"\-|minus"#
    case multiply = #"\*|multiply"#
    case dividedBy = #"\/|divided by"#
    
    var precedence: Int {
        switch self {
        case .plus, .minus: return 10
        case .multiply, .dividedBy: return 20
        }
    }
    
    private static let all = [Operator.plus,
                              Operator.minus,
                              Operator.multiply,
                              Operator.dividedBy]
    
    static var regex: String {
        return all
            .map { $0.rawValue }
            .joined(separator: "|")
    }
    
    // 😆 So bad!
    public init?(rawValue: String) {
        switch rawValue {
        case "+", "plus": self = .plus
        case "-", "minus": self = .minus
        case "*", "multiply": self = .multiply
        case "/", "divided by": self = .dividedBy
        default: return nil
        }
    }
}
