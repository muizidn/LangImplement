//
//  FunctionCall.swift
//  LangImplementLib
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation

enum RuntimeError: Error {
    case alreadyDefined(String)
}

struct FunctionCall: Node {
    let identifier: String
    let parameters: [Node]
    func interpret() throws -> Float {
        guard let definition = SymbolTable.identifiers[identifier],
            case let .function(function) = definition else {
                throw Parser.Error.notDefined(identifier)
        }
        
        guard parameters.count == function.parameters.count else {
            throw Parser.Error.invalidParameters(toFunction: identifier)
        }
        
        let paramsAndValues = zip(function.parameters, parameters)
        try paramsAndValues.forEach({ (key, value) in
            guard SymbolTable.identifiers[key] == nil else {
                throw RuntimeError.alreadyDefined(key)
            }
            SymbolTable.identifiers[key] = .variable(try value.interpret())
        })
        let returnValue = try function.block.interpret()
        paramsAndValues.forEach { (key, _) in
            SymbolTable.identifiers.removeValue(forKey: key)
        }
        return returnValue
    }
}
