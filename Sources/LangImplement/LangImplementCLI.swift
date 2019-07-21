import Foundation
import LangImplementLib

fileprivate enum Error: Swift.Error {
    case noCode
}

class LangImplementCLI: CLI {
    let fm = FileManager.init()
    
    override func run() throws {
        guard arguments.count >= 2 else {
            throw Error.noCode
        }
        
        let fileURL = resolvePath(fileName: arguments[1])
        let code = try readSourceFile(url: fileURL)
        let lexer = Lexer(code: code)
        let parser = Parser(tokens: lexer.tokens)
        let ast = try parser.parse()
        let output = try ast.interpret()
        print(output)
    }
    
    private func resolvePath(fileName: String) -> URL {
        let dir = fm.currentDirectoryPath
        let filePath = "\(dir)/\(fileName)"
        return URL(fileURLWithPath: filePath)
    }
    
    private func readSourceFile(url: URL) throws -> String {
        return try String(contentsOf: url)
    }
}
