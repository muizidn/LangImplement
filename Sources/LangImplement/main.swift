let tool = LangImplementCLI()
do {
    try tool.run()
} catch {
    print("Whoops: \(error)")
}
