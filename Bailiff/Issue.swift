//
//  Issue.swift
//  Bailiff
//
//  Created by Romain Pouclet on 2016-05-05.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation

public func extractIssueInfo(content content: String) -> (String, String?) {
    guard let position = content.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()) else {
        return (content, nil)
    }

    let title = content.substringToIndex(position.startIndex)
    let issueContent = content.substringWithRange(position.startIndex..<content.endIndex)

    return (title, issueContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
}
