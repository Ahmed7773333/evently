//
//  SampleData.swift
//  evently
//

import Foundation
import SwiftData

@MainActor
enum SampleData {
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Category>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        guard existingCount == 0 else { return }

        let sports = Category(name: "Sport", image: "figure.run")
        let birthday = Category(name: "Birthday", image: "birthday.cake")
        let meeting = Category(name: "Meeting", image: "person.2.fill")
        let gaming = Category(name: "Gaming", image: "gamecontroller.fill")
        let music = Category(name: "Music", image: "music.note")

        context.insert(sports)
        context.insert(birthday)
        context.insert(meeting)
        context.insert(gaming)
        context.insert(music)

        let sampleEvents: [Event] = [
            Event(
                title: "Annual Tech Conference",
                eventDescription: "Join us for inspiring keynotes, live SwiftUI workshops, and networking with engineers around the globe.",
                image: "eventimage",
                date: Date().addingTimeInterval(86400 * 3),
                location: "Innovation Hub, Downtown",
                category: meeting,
                isFav: true
            ),
            Event(
                title: "Alex's Birthday Bash",
                eventDescription: "Celebrating another fantastic year with cake, live music, games, and great friends!",
                image: "eventimage",
                date: Date().addingTimeInterval(86400 * 7),
                location: "Skyline Rooftop Lounge",
                category: birthday,
                isFav: false
            ),
            Event(
                title: "Weekend Marathon 10K",
                eventDescription: "Ready, set, go! A community morning run through the city park with refreshments at the finish line.",
                image: "eventimage",
                date: Date().addingTimeInterval(86400 * 12),
                location: "Central City Park",
                category: sports,
                isFav: true
            ),
            Event(
                title: "Indie Music Night",
                eventDescription: "An acoustic evening featuring emerging local artists under the stars.",
                image: "eventimage",
                date: Date().addingTimeInterval(86400 * 15),
                location: "Harbor Amphitheater",
                category: music,
                isFav: false
            ),
            Event(
                title: "Retro Gaming Tournament",
                eventDescription: "Compete in classic arcade and couch co-op challenges for prizes and bragging rights.",
                image: "eventimage",
                date: Date().addingTimeInterval(86400 * 20),
                location: "Pixel Arena Cafe",
                category: gaming,
                isFav: true
            )
        ]

        for event in sampleEvents {
            context.insert(event)
        }

        try? context.save()
    }
}
