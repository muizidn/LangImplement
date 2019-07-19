import Foundation

public class Lexer {
    public let tokens: [Token]
    private static func getNextPrefix(code: String) -> (regex: String, prefix: String)? {
        var prefix: String? = nil
        let keyValue = Token.generators
            .first { (regex, generator) -> Bool in
                prefix = code.getPrefix(regex: regex)
                return prefix != nil }
        
        guard let regex = keyValue?.key,
            keyValue?.value != nil else { return nil }
        
        return (regex, prefix!)
        
    }
    
    public init(code: String) {
        var code = code
        code.trimLeadingWhitespace()
        var tokens = [Token]()
        while let next = Lexer.getNextPrefix(code: code) {
            let (regex, prefix) = next
            code = String(code[prefix.endIndex...])
            code.trimLeadingWhitespace()
            guard let generator = Token.generators[regex],
                let token = generator(prefix) else { fatalError() }
            tokens.append(token)
        }
        self.tokens = tokens
    }
}

extension Lexer: CustomStringConvertible {
    public var description: String {
        return tokens.description
    }
}
