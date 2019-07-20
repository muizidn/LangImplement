//
//  CLI.swift
//  LangImplement
//
//  Created by PondokIOS on 20/07/19.
//

import Foundation

class CLI {
    let arguments: [String]
    init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    func run() throws {
      fatalError("Unimplemented")
    }
}
