//
//  CategoriesBar.swift
//  evently
//
//  Created by M1 PRO on 10/18/26.
//

import SwiftUI
import SwiftData

struct CategoriesBar: View {
    var categories: [Category]

    // nil represents the "All" category.
    @Binding var selectedCategory: Category?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // 1. The "All" Tab
                Button {
                    withAnimation(.snappy) {
                        selectedCategory = nil
                    }
                } label: {
                    CategoryTab(
                        name: String(localized: "All"),
                        iconName: "square.grid.2x2",
                        isSelected: selectedCategory == nil
                    )
                }
                .buttonStyle(.plain)

                // 2. The Dynamic Category Tabs
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
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct CategoryTab: View {
    var name: String
    var iconName: String
    var isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isSelected ? .white : AppTheme.primaryBlue)

            Text(name)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? AppTheme.brandBlue : AppTheme.surface)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(isSelected ? Color.clear : AppTheme.border, lineWidth: 1)
        )
    }
}

#Preview {
    struct PreviewWrapper: View {
        let mockCategory1 = Category(name: "Sport", image: "figure.run")
        let mockCategory2 = Category(name: "Birthday", image: "birthday.cake")

        @State private var selected: Category? = nil

        var body: some View {
            CategoriesBar(
                categories: [mockCategory1, mockCategory2],
                selectedCategory: $selected
            )
        }
    }

    return PreviewWrapper()
}
