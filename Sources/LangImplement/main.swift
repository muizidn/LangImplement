import LangImplementLib

let code = "1 + 2 * 3 divided by 5"
let lexer = Lexer(code: code)
print(lexer.description)
let parser = Parser(tokens: lexer.tokens)
print(try parser.parse().description)
