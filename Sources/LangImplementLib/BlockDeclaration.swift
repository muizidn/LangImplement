//
//  BlockDeclaration.swift
//  LangImplement
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation

struct BlockDeclaration: Node {
    let nodes: [Node]
    func interpret() throws -> Float {
        for line in nodes[0..<(nodes.endIndex - 1)] {
            _ = try line.interpret()
        }
        guard let last = nodes.last else {
            throw Parser.Error.requireExpression
        }
        return try last.interpret()
    }
}
