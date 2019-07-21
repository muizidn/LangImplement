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

var identifiers: [String: Float] = [:]

extension String: Node {
    public func interpret() throws -> Float {
        guard let value = identifiers[self] else {
            throw Parser.Error.notDefined(self)
        }
        return value
    }
}
struct InfixOperation: Node {
    let op: Operator
    let lhs: Node
    let rhs: Node
    
    func interpret() throws -> Float {
        let left = try lhs.interpret()
        let right = try rhs.interpret()
        switch op {
        case .plus:
            return left + right
        case .minus:
            return left - right
        case .multiply:
            return left * right
        case .dividedBy:
            return left / right
        }
    }
}
