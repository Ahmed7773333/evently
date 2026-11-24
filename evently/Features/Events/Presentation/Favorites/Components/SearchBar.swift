//
//  SearchBar.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: LocalizedStringKey = "Search events..."

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.body.weight(.semibold))
                .foregroundStyle(AppTheme.primaryBlue)

            TextField(placeholder, text: $text)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    withAnimation(.snappy) {
                        text = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1.2)
        )
    }
}

#Preview {
    @Previewable @State var query = ""
    SearchBar(text: $query)
        .padding()
}
