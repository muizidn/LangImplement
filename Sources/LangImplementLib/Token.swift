//
//  Token.swift
//  LangImplementLib
//
//  Created by PondokIOS on 14/07/19.
//

import Foundation

public enum Token {
    typealias Generator = (String) -> Token?
    
    case op(Operator) //Operation Code
    case number(Float)
    case parensOpen
    case parensClose
    
    static var generators: [String: Generator] {
        return [
            Operator.regex: { .op(Operator(rawValue: $0)!) },
            #"\-?[0-9]*\.[0-9]+|[0-9]+"#: { .number(Float($0)!) },
            #"\("#: { _ in .parensOpen },
            #"\)"#: { _ in .parensClose },
        ]
    }
}
