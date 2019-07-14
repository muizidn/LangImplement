//
//  Token.swift
//  LangImplementLib
//
//  Created by PondokIOS on 14/07/19.
//

import Foundation

enum Token {
    typealias Generator = (String) -> Token?
    
    case op(String) //Operation Code
    case number(Float)
    case parensOpen
    case parensClose
    
    static var generators: [String: Generator] {
        return [
            #"\*|\/|\+|\-|times|divided by|plus|minus"#: { .op($0) },
            #"\-[0-9]*\.[0-9]+|[0-9]+"#: { .number(Float($0)!) },
            #"\("#: { _ in .parensOpen },
            #"\)"#: { _ in .parensClose },
        ]
    }
}
