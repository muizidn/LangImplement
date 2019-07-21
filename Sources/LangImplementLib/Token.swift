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
    case `var`
    case equals
    case function
    case curlyOpen
    case curlyClose
    case comma
    
    static var generators: [String: Generator] {
        return [
            #"\+|\-|\*|\/"#: { .op(Operator(rawValue: $0)!) },
            #"\-?[0-9]*\.[0-9]+|[0-9]+"#: { .number(Float($0)!) },
            #"\("#: { _ in .parensOpen },
            #"\)"#: { _ in .parensClose },
            #"[a-zA-Z_$][a-zA-Z_$0-9]*"#: {
                guard $0 != "var" else { return .var }
                guard $0 != "function" else { return .function }
                return .identifier($0)
            },
            #"\="#: { _ in .equals },
            #"\{"#: { _ in .curlyOpen },
            #"\}"#: { _ in .curlyClose },
            #"\,"#: { _ in .comma },
        ]
    }
}
