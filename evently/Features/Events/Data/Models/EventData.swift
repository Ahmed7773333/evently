//
//  EventData.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import Foundation
import SwiftData

@Model
final class Event {
    var id: UUID = UUID()
    var title: String
    var eventDescription: String
    var image: String
    var imageData: Data? = nil
    var date: Date
    var location: String = ""
    var isFav: Bool
    var createdAt: Date = Date()
    var category: Category?

    init(
        id: UUID = UUID(),
        title: String,
        eventDescription: String,
        image: String = "eventimage",
        imageData: Data? = nil,
        date: Date = .now,
        location: String = "",
        category: Category? = nil,
        isFav: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.eventDescription = eventDescription
        self.image = image
        self.imageData = imageData
        self.date = date
        self.location = location
        self.category = category
        self.isFav = isFav
        self.createdAt = createdAt
    }
}
