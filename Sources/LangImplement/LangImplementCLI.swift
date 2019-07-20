import Foundation
import LangImplementLib

fileprivate enum Error: Swift.Error {
    case noCode
}

class LangImplementCLI: CLI {
    override func run() throws {
        guard arguments.count >= 2 else {
            throw Error.noCode
        }
        let code = arguments[1]
        let lexer = Lexer(code: code)
        let parser = Parser(tokens: lexer.tokens)
        let ast = try parser.parse()
        let output = try ast.interpret()
        print(output)
    }
}
