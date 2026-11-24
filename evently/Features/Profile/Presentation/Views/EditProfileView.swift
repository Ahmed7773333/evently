//
//  EditProfileView.swift
//  evently
//

import SwiftUI

struct EditProfileView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(AppRouter.self) private var router

    @State private var name: String = ""
    @State private var email: String = ""

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        #if os(iOS)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        #endif
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Edit Profile")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        router.dismissSheet()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        settings.updateProfile(name: name, email: email)
                        router.dismissSheet()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                name = settings.userProfile.name
                email = settings.userProfile.email
            }
        }
    }
}

#Preview {
    EditProfileView()
        .environment(AppSettings())
        .environment(AppRouter(initialRoot: .main))
}
