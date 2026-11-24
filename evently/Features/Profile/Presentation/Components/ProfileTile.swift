//
//  ProfileTile.swift
//  evently
//
//  Created by M1 PRO on 10/19/26.
//

import SwiftUI

struct ProfileTile: View {
    var title: LocalizedStringKey
    var subtitle: String? = nil
    var icon: String
    var isDestructive: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isDestructive ? .red : AppTheme.primaryBlue)
                    .frame(width: 36, height: 36)
                    .background((isDestructive ? Color.red : AppTheme.primaryBlue).opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(isDestructive ? .red : .primary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.forward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 12) {
        ProfileTile(title: "Dark Mode", subtitle: "Appearance", icon: "moon.fill", action: {})
        ProfileTile(title: "Logout", icon: "iphone.and.arrow.right.outward", isDestructive: true, action: {})
    }
    .padding()
    .background(AppTheme.background)
}
