//
//  FunctionDefinition.swift
//  LangImplementLib
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation

struct FunctionDefinition: Node {
    let name: String
    let parameters: [String]
    let block: Node
    func interpret() throws -> Float {
        SymbolTable.identifiers[name] = .function(self)
        return 1
    }
}
