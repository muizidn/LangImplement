//
//  Definition.swift
//  LangImplementLib
//
//  Created by PondokIOS on 21/07/19.
//

import Foundation

enum Definition {
    case variable(Float)
    case function(FunctionDefinition)
    case invalidParameters(toFunction: String)
    case alreadyDefined(String)
}
