//
//  Parser.swift
//  LangImplementLib
//
//  Created by PondokIOS on 19/07/19.
//

import Foundation

public class Parser {
    enum Error: Swift.Error {
        case requireExpression
        case expected(String)
        case expectedNumber
        case expectedOperator
        
    }
    let tokens: [Token]
    var index  = 0
    public init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    var canPop: Bool {
        return index < tokens.count
    }
    
    func peek() -> Token {
        return tokens[index]
    }
    
    func popToken() -> Token {
        let token = tokens[index]
        index += 1
        return token
    }
    
    func parseNumber() throws -> Node {
        guard case let .number(value) = popToken() else {
            throw Error.expectedNumber
        }
        return value
    }
    
    func parseParens() throws -> Node {
        guard case .parensOpen = popToken() else {
            throw Error.expected("(")
        }
        let expressionNode = try parse()
        guard case .parensClose = popToken() else {
            throw Error.expected(")")
        }
        return expressionNode
    }
    
    func parseValue() throws -> Node {
        switch peek() {
        case .number:
            return try parseNumber()
        case .parensOpen:
            return try parseParens()
        default:
            throw Error.expected("<Expression>")
        }
    }
    
    func peekPrecedence() throws -> Int {
        guard canPop, case let .op(op) = peek() else {
            return -1
        }
        return op.precedence
    }
    
    func parseInfixOperation(node: Node, nodePrecedence: Int = 0) throws -> Node {
        var leftNode = node
        while let precendence = Optional.some(try peekPrecedence()),
            precendence >= nodePrecedence {
                guard case let .op(op) = popToken() else {
                    throw Error.expectedOperator
                }
                var rightNode = try parseValue()
                let nextPrecedence = try peekPrecedence()
                
                if precendence < nextPrecedence {
                    rightNode = try parseInfixOperation(
                        node: rightNode,
                        nodePrecedence: precendence + 1)
                }
                leftNode = InfixOperation(op: op, lhs: leftNode, rhs: rightNode)
        }
        return leftNode
    }
    
    public func parse() throws -> Node {
        guard canPop else { throw Error.requireExpression }
        let node = try parseValue()
        return try parseInfixOperation(node: node)
    }
}

public protocol Node: CustomStringConvertible {
    func interpret() throws -> Float
}
extension Float: Node {
    public func interpret() throws -> Float {
        return self
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
    
    var description: String {
        return "\(lhs) \(op) \(rhs)"
    }
}
