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
    case identifier(String)
    
    static var generators: [String: Generator] {
        return [
            Operator.regex: { .op(Operator(rawValue: $0)!) },
            #"\-?[0-9]*\.[0-9]+|[0-9]+"#: { .number(Float($0)!) },
            #"\("#: { _ in .parensOpen },
            #"\)"#: { _ in .parensClose },
            #"[a-zA-Z_$][a-zA-Z_$0-9]*"#: { .identifier($0) }
        ]
    }
}
