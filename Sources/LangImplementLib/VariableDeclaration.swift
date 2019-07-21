//
//  VariableDeclaration.swift
//  LangImplement
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation

struct VariableDeclaration: Node {
    let name: String
    let value: Node
    func interpret() throws -> Float {
        let val = try value.interpret()
        if SymbolTable.identifiers[name] == nil {
            SymbolTable.identifiers[name] = .variable(val)
        } else {
            throw Parser.Error.alreadyDefined(identifier: name)
        }
        return val
    }
}
