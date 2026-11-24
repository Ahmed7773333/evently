//
//  CategoryData.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID = UUID()
    var name: String
    var image: String

    // One Category has Many Events
    // inverse: \Event.category tells SwiftData these two properties are linked
    @Relationship(deleteRule: .cascade, inverse: \Event.category)
    var events: [Event] = []

    init(id: UUID = UUID(), name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}
