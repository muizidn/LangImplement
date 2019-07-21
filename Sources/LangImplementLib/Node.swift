//
//  Node.swift
//  LangImplement
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation

public protocol Node {
    func interpret() throws -> Float
}
extension Float: Node {
    public func interpret() throws -> Float {
        return self
    }
}

extension String: Node {
    public func interpret() throws -> Float {
        guard case let .variable(value)? = SymbolTable.identifiers[self] else {
            throw Parser.Error.notDefined(self)
        }
        return value
    }
}
