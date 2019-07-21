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
        case alreadyDefined(identifier: String)
        case invalidParameters(toFunction: String)
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
            case .function:
                let definition = try parseFunctionDefinition()
                nodes.append(definition)
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
            guard let identifier = try parseIdentifier() as? String else {
                throw Error.expectedIdentifier
            }
            guard canPop, case .parensOpen = peek() else {
                return identifier
            }
            
            let params = try parseParameterList()
            return FunctionCall(identifier: identifier, parameters: params)
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
    
    func parseParameterList() throws -> [Node] {
        var params: [Node] = []
        guard case .parensOpen = popToken() else {
            throw Error.expected("(")
        }
        while canPop {
            guard let value = try? parseValue() else {
                break
            }
            guard case .comma = peek() else {
                params.append(value)
                break
            }
            
            _ = popToken()
            params.append(value)
        }
        guard canPop, case .parensClose = popToken() else {
            throw Error.expected(")")
        }
        return params
    }
    
    func parseFunctionDefinition() throws -> Node {
        guard case .function = popToken() else {
            throw Error.expected("function")
        }
        
        guard case let .identifier(identifier) = popToken() else {
            throw Error.expectedIdentifier
        }
        
        let paramsNodes = try parseParameterList()
        let paramList = try paramsNodes
            .map { node -> String in
                guard let string = node as? String else {
                    throw Error.expectedIdentifier
                }
                return string
        }
        
        guard case .curlyOpen = popToken() else {
            throw Error.expected("{")
        }
        
        let startIndex = index
        while canPop {
            guard case .curlyClose = peek() else {
                index += 1
                continue
            }
            break
        }
        
        let endIndex = index
        
        guard case .curlyClose = popToken() else {
            throw Error.expected("}")
        }
        
        let codeBlock = try Parser(tokens: Array(tokens[startIndex..<endIndex])).parse()
        
        return FunctionDefinition(
            name: identifier,
            parameters: paramList,
            block: codeBlock
        )
    }
}

