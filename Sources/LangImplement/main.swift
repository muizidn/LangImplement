let tool = LangImplementCLI(
    arguments: [
        "",
"""
var n = 10
var x = 19
var c = n + x
c + 10
"""
    ]
)
do {
    try tool.run()
} catch {
    print("Whoops: \(error)")
}
