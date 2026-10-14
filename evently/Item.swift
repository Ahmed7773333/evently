//
//  Item.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
