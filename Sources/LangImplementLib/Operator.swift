//
//  Operator.swift
//  LangImplementLib
//
//  Created by PondokIOS on 19/07/19.
//

import Foundation

public enum Operator: String, RawRepresentable {
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case dividedBy = "/"
    
    var precedence: Int {
        switch self {
        case .plus, .minus: return 10
        case .multiply, .dividedBy: return 20
        }
    }
}
