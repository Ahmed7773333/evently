//
//  CreateEditEventView.swift
//  evently
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateEditEventView: View {
    enum Mode: Equatable {
        case create
        case edit(eventID: UUID)
    }

    let mode: Mode

    @Environment(AppRouter.self) private var router
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Category.name) private var categories: [Category]
    @Query private var events: [Event]

    @State private var title: String = ""
    @State private var eventDescription: String = ""
    @State private var location: String = ""
    @State private var date: Date = Date().addingTimeInterval(3600)
    @State private var selectedCategory: Category?
    @State private var isFav: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var hasLoadedInitialData = false

    private var existingEvent: Event? {
        guard case .edit(let eventID) = mode else { return nil }
        return events.first { $0.id == eventID }
    }

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    coverImageSection
                    categorySection
                    detailsSection
                    scheduleSection
                    favoriteToggleSection
                    saveButton
                }
                .padding(16)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(isEditing ? "Edit Event" : "Create Event")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        closeView()
                    }
                }
            }
            .onAppear {
                loadInitialStateIfNeeded()
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }

    // MARK: - Subviews

    private var coverImageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                EventImageView(imageName: "eventimage", imageData: selectedImageData)
                    .frame(height: 190)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )

                HStack(spacing: 8) {
                    if selectedImageData != nil {
                        Button {
                            selectedImageData = nil
                            selectedPhotoItem = nil
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(.black.opacity(0.65))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Reset Cover Image")
                    }

                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Choose Photo", systemImage: "photo.badge.plus")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppTheme.brandBlue.opacity(0.92))
                            .clipShape(Capsule())
                    }
                }
                .padding(12)
            }
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories) { category in
                        Button {
                            withAnimation(.snappy) {
                                selectedCategory = category
                            }
                        } label: {
                            CategoryTab(
                                name: category.name,
                                iconName: category.image,
                                isSelected: selectedCategory?.id == category.id
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Title")
                    .font(.headline)
                TextField("Event Title", text: $title)
                    .padding(14)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Description")
                    .font(.headline)
                TextField("Describe your event...", text: $eventDescription, axis: .vertical)
                    .lineLimit(4...7)
                    .padding(14)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Location")
                    .font(.headline)
                HStack(spacing: 10) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(AppTheme.primaryBlue)
                    TextField("Venue or address", text: $location)
                }
                .padding(14)
                .background(AppTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
            }
        }
    }

    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Date & Time")
                .font(.headline)

            VStack(spacing: 12) {
                DatePicker(
                    "Event Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                Divider()
                DatePicker(
                    "Event Time",
                    selection: $date,
                    displayedComponents: [.hourAndMinute]
                )
            }
            .padding(14)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
        }
    }

    private var favoriteToggleSection: some View {
        Toggle(isOn: $isFav) {
            Label("Add to Favorites", systemImage: isFav ? "heart.fill" : "heart")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .tint(AppTheme.brandBlue)
        .padding(14)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
    }

    private var saveButton: some View {
        Button {
            saveEvent()
        } label: {
            Text(isEditing ? "Update Event" : "Add Event")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(canSave ? AppTheme.brandBlue : Color.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(!canSave)
        .padding(.top, 8)
    }

    // MARK: - Actions

    private func loadInitialStateIfNeeded() {
        guard !hasLoadedInitialData else { return }
        hasLoadedInitialData = true

        if let event = existingEvent {
            title = event.title
            eventDescription = event.eventDescription
            location = event.location
            date = event.date
            selectedCategory = event.category ?? categories.first
            isFav = event.isFav
            selectedImageData = event.imageData
        } else {
            selectedCategory = categories.first
        }
    }

    private func saveEvent() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = eventDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        if let event = existingEvent {
            event.title = trimmedTitle
            event.eventDescription = trimmedDescription
            event.location = trimmedLocation
            event.date = date
            event.category = selectedCategory
            event.isFav = isFav
            event.imageData = selectedImageData
        } else {
            let newEvent = Event(
                title: trimmedTitle,
                eventDescription: trimmedDescription,
                image: "eventimage",
                imageData: selectedImageData,
                date: date,
                location: trimmedLocation,
                category: selectedCategory,
                isFav: isFav
            )
            modelContext.insert(newEvent)
        }

        try? modelContext.save()
        closeView()
    }

    private func closeView() {
        if router.activeSheet != nil {
            router.dismissSheet()
        } else {
            dismiss()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, Category.self, configurations: config)
    SampleData.seedIfNeeded(context: container.mainContext)

    return CreateEditEventView(mode: .create)
        .environment(AppRouter(initialRoot: .main))
        .modelContainer(container)
}
