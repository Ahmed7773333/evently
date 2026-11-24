//
//  EventDetailsView.swift
//  evently
//

import SwiftUI
import SwiftData

struct EventDetailsView: View {
    let eventID: UUID

    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]

    @State private var showDeleteConfirmation = false

    private var event: Event? {
        events.first { $0.id == eventID }
    }

    var body: some View {
        Group {
            if let event {
                eventContent(for: event)
            } else {
                ContentUnavailableView(
                    "Event Not Found",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("This event may have been removed.")
                )
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle("Event Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            if let event {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        router.presentSheet(.editEvent(eventID: event.id))
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(AppTheme.primaryBlue)
                    }
                    .accessibilityLabel("Edit Event")

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                    .accessibilityLabel("Delete Event")
                }
            }
        }
        .alert("Delete Event?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteEvent()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    @ViewBuilder
    private func eventContent(for event: Event) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero Image with Category Badge & Favorite Button
                ZStack(alignment: .topLeading) {
                    EventImageView(imageName: event.image, imageData: event.imageData)
                        .frame(height: 240)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppTheme.border, lineWidth: 1)
                        )

                    HStack {
                        if let category = event.category {
                            Label(category.name, systemImage: category.image)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AppTheme.primaryBlue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(AppTheme.pillBackground)
                                .clipShape(Capsule())
                        }

                        Spacer()

                        Button {
                            withAnimation(.snappy) {
                                event.isFav.toggle()
                                try? modelContext.save()
                            }
                        } label: {
                            Image(systemName: event.isFav ? "heart.fill" : "heart")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(AppTheme.primaryBlue)
                                .padding(10)
                                .background(AppTheme.pillBackground)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(event.isFav ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .padding(12)
                }

                // Title
                Text(event.title)
                    .font(.title.bold())
                    .foregroundStyle(.primary)

                // Date & Time Card
                infoCard(
                    icon: "calendar.badge.clock",
                    title: event.date.formatted(date: .complete, time: .omitted),
                    subtitle: event.date.formatted(date: .omitted, time: .shortened)
                )

                // Location Card
                if !event.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    infoCard(
                        icon: "mappin.and.ellipse",
                        title: "Location",
                        subtitle: event.location
                    )
                }

                // Description Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(event.eventDescription.isEmpty ? "No description provided." : event.eventDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
                .background(AppTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
            }
            .padding(16)
        }
    }

    private func infoCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(AppTheme.brandBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.primaryBlue)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
    }

    private func deleteEvent() {
        guard let event else { return }
        modelContext.delete(event)
        try? modelContext.save()
        router.pop()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    let category = Category(name: "Birthday", image: "birthday.cake")
    let sampleEvent = Event(
        title: "Alex's Birthday Bash",
        eventDescription: "Celebrating another fantastic year with cake, music, and great friends!",
        image: "eventimage",
        date: Date().addingTimeInterval(86400 * 5),
        location: "Skyline Rooftop Lounge",
        category: category,
        isFav: true
    )
    container.mainContext.insert(category)
    container.mainContext.insert(sampleEvent)

    return NavigationStack {
        EventDetailsView(eventID: sampleEvent.id)
    }
    .environment(AppRouter(initialRoot: .main))
    .modelContainer(container)
}
