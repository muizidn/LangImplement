//
//  String+getPrefix.swift
//  LangImplementLib
//
//  Created by PondokIOS on 14/07/19.
//

import Foundation

public extension String {
    func getPrefix(regex: String) -> String? {
        let expression = try! NSRegularExpression(pattern: "^\(regex)", options: [])
        let range = expression.rangeOfFirstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count))
        if range.location == 0 {
            return (self as NSString).substring(with: range)
        }
        return nil
    }
    
    mutating func trimLeadingWhitespace() {
        let i = startIndex
        while i < endIndex {
            guard CharacterSet.whitespacesAndNewlines
                .contains(self[i].unicodeScalars.first!) else { return }
            self.remove(at: i)
        }
        
    }
}
