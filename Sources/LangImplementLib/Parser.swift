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
        case expectedIdentifier
        case notDefined(String)
        
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
    
    func peekPrecedence() throws -> Int {
        guard canPop, case let .op(op) = peek() else {
            return -1
        }
        return op.precedence
    }
    
    public func parse() throws -> Node {
        var nodes = [Node]()
        while canPop {
            let token = peek()
            switch token {
            case .var:
                let decl = try parseVariableDeclaration()
                nodes.append(decl)
            default:
                let expr = try parseExpression()
                nodes.append(expr)
            }
        }
        return BlockDeclaration(nodes: nodes)
    }
}

extension Parser {
    
    func parseExpression() throws -> Node {
        guard canPop else { throw Error.requireExpression }
        let node = try parseValue()
        return try parseInfixOperation(node: node)
    }
    
    func parseValue() throws -> Node {
        switch peek() {
        case .number:
            return try parseNumber()
        case .parensOpen:
            return try parseParens()
        case .identifier:
            return try parseIdentifier()
        default:
            throw Error.expected("<Expression>")
        }
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
        let expressionNode = try parseExpression()
        guard case .parensClose = popToken() else {
            throw Error.expected(")")
        }
        return expressionNode
    }
    
    func parseIdentifier() throws -> Node {
        guard case let .identifier(id) = popToken() else {
            throw Error.expectedIdentifier
        }
        return id
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
    
    func parseVariableDeclaration() throws -> Node {
        guard case .var = popToken() else {
            throw Error.expected("'var' keyword")
        }
        
        guard case let .identifier(name) = popToken() else {
            throw Error.expectedIdentifier
        }
        
        guard case .equals = popToken() else {
            throw Error.expected("'=' token")
        }
        
        let expression = try parseExpression()
        return VariableDeclaration(name: name, value: expression)
    }
}

