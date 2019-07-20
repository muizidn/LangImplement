let tool = LangImplementCLI(
    arguments: [
        "",
        "10 * PI"
    ]
)
do {
    try tool.run()
} catch {
    print("Whoops: \(error)")
}
