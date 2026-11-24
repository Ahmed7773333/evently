//
//  EventCard.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI
import SwiftData

struct EventCard: View {
    @Bindable var event: Event
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // 1. Background Event Image
            EventImageView(imageName: event.image, imageData: event.imageData)
                .frame(height: 205)
                .frame(maxWidth: .infinity)
                .clipped()

            // 2. Foreground Overlay (Top Date Badge + Bottom Title Bar)
            VStack(alignment: .leading) {
                HStack {
                    // Top-Left Date Badge ("21 Jan")
                    VStack(spacing: -2) {
                        Text(event.date.formatted(.dateTime.day()))
                            .font(.system(size: 16, weight: .bold))
                        Text(event.date.formatted(.dateTime.month(.abbreviated)))
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundStyle(AppTheme.primaryBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppTheme.pillBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    Spacer()

                    if let category = event.category {
                        Label(category.name, systemImage: category.image)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.primaryBlue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(AppTheme.pillBackground)
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                // Bottom Bar (Event Title + Heart Button)
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        if !event.location.isEmpty {
                            Label(event.location, systemImage: "mappin")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    Button {
                        withAnimation(.snappy) {
                            event.isFav.toggle()
                            try? modelContext.save()
                        }
                    } label: {
                        Image(systemName: event.isFav ? "heart.fill" : "heart")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(AppTheme.primaryBlue)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(event.isFav ? "Remove from Favorites" : "Add to Favorites")
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(AppTheme.pillBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .padding(10)
        }
        .frame(height: 205)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
    }
}

#Preview {
    let mockCategory = Category(name: "Birthday", image: "birthday.cake")
    let sampleEvent = Event(
        title: "This is a Birthday Party",
        eventDescription: "Description",
        image: "eventimage",
        date: Date(),
        location: "Skyline Rooftop Lounge",
        category: mockCategory,
        isFav: true
    )

    EventCard(event: sampleEvent)
        .padding()
}
