//
//  InfixOperation.swift
//  LangImplement
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation


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
