//
//  ListOfEvents.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI
import SwiftData

struct ListOfEvents: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext

    var selectedCategory: Category? = nil
    @Query(sort: \Event.date, order: .forward) private var events: [Event]

    private var filteredEvents: [Event] {
        if let selectedCategory {
            return events.filter { $0.category?.id == selectedCategory.id }
        } else {
            return events
        }
    }

    var body: some View {
        if filteredEvents.isEmpty {
            ContentUnavailableView {
                Label("No Events Found", systemImage: "calendar.badge.plus")
            } description: {
                if let selectedCategory {
                    Text("There are no events in \(selectedCategory.name) yet.")
                } else {
                    Text("Tap the + button to create your first event.")
                }
            } actions: {
                Button("Create Event") {
                    router.presentSheet(.createEvent)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.brandBlue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                ForEach(filteredEvents) { event in
                    EventCard(event: event)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            router.push(.eventDetails(eventID: event.id))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(event)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                withAnimation(.snappy) {
                                    event.isFav.toggle()
                                    try? modelContext.save()
                                }
                            } label: {
                                Label(
                                    event.isFav ? "Unfavorite" : "Favorite",
                                    systemImage: event.isFav ? "heart.slash" : "heart.fill"
                                )
                            }
                            .tint(AppTheme.brandBlue)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                }

                // Bottom spacing so the floating action button never obscures the last card
                Color.clear
                    .frame(height: 80)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    private func delete(_ event: Event) {
        withAnimation {
            modelContext.delete(event)
            try? modelContext.save()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return ListOfEvents()
        .environment(AppRouter(initialRoot: .main))
        .modelContainer(container)
}
