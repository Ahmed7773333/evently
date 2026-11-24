//
//  OnboardingView.swift
//  evently
//
//  Created by M1 PRO on 10/14/26.
//

import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: OnboardingViewModel
    @Namespace private var buttonNamespace
    
        // Helper to map token names to dynamic colors for demonstration
    private func accentColor(for index: Int) -> Color {
        switch index {
            case 0: return .indigo
            case 1: return .purple
            default: return .blue
        }
    }
    
    var body: some View {
        ZStack {
                // 1. Living Ambient Background (Adapts automatically to Light/Dark mode)
            ambientBackground
            
            VStack(spacing: 0) {
                    // 2. Top Bar (Skip Button)
                topBar
                
                    // 3. Modern Paging ScrollView with Interactive Scroll Transitions
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.steps) { step in
                            OnboardingStepCardView(
                                step: step,
                                accentColor: accentColor(for: step.id)
                            )
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.3)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.82)
                                    .offset(y: phase.isIdentity ? 0 : 25)
                                    .blur(radius: phase.isIdentity ? 0 : 4)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .scrollPosition(id: $viewModel.currentStepID)
                .animation(.spring(duration: 0.45, bounce: 0.2), value: viewModel.currentStepID)
                
                    // 4. Bottom Controls (Morphing Indicators + Morphing CTA Button)
                bottomControls
            }
        }
    }
    
        // MARK: - Subviews
    
    private var ambientBackground: some View {
        ZStack {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
            
            Circle()
                .fill(accentColor(for: viewModel.currentIndex).opacity(0.22))
                .frame(width: 340, height: 340)
                .blur(radius: 85)
                .offset(
                    x: viewModel.currentIndex.isMultiple(of: 2) ? -90 : 90,
                    y: -140
                )
                .animation(.easeInOut(duration: 0.8), value: viewModel.currentIndex)
        }
    }

    
    private var topBar: some View {
        HStack {
            Spacer()
            if !viewModel.isLastStep {
                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        viewModel.skipButtonTapped()
                    }
                } label: {
                    Text(LocalizedStringKey("onboarding.skip"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .animation(.snappy, value: viewModel.isLastStep)
    }
    
    private var bottomControls: some View {
        VStack(spacing: 32) {
                // Morphing Capsule Page Indicator
            HStack(spacing: 8) {
                ForEach(viewModel.steps) { step in
                    let isSelected = viewModel.currentIndex == step.id
                    Capsule()
                        .fill(isSelected ? accentColor(for: viewModel.currentIndex) : Color.primary.opacity(0.2))
                        .frame(width: isSelected ? 32 : 8, height: 8)
                        .animation(.spring(duration: 0.35, bounce: 0.3), value: viewModel.currentIndex)
                }
            }
            
                // Morphing Next / Get Started Button using @Namespace
            Button {
                withAnimation(.spring(duration: 0.45, bounce: 0.25)) {
                    viewModel.nextButtonTapped()
                }
            } label: {
                ZStack {
                    if viewModel.isLastStep {
                        HStack(spacing: 10) {
                            Text(LocalizedStringKey("onboarding.getStarted"))
                                .font(.headline)
                                // Automatically flips in Arabic RTL!
                            Image(systemName: "arrow.forward")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            Capsule()
                                .fill(accentColor(for: viewModel.currentIndex))
                                .matchedGeometryEffect(id: "ctaBackground", in: buttonNamespace)
                        )
                    } else {
                        Image(systemName: "arrow.forward")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 62, height: 62)
                            .background(
                                Circle()
                                    .fill(accentColor(for: viewModel.currentIndex))
                                    .matchedGeometryEffect(id: "ctaBackground", in: buttonNamespace)
                            )
                    }
                }
                .shadow(
                    color: accentColor(for: viewModel.currentIndex).opacity(0.35),
                    radius: 14, x: 0, y: 8
                )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 32)
    }
}

    // MARK: - Individual Step Card View
private struct OnboardingStepCardView: View {
    let step: OnboardingStep
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
                // Animated SF Symbol Hero Container
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 220, height: 220)
                
                Circle()
                    .strokeBorder(accentColor.opacity(0.25), lineWidth: 1.5)
                    .frame(width: 170, height: 170)
                
                Image(systemName: step.symbolName)
                    .font(.system(size: 76, weight: .semibold))
                    .foregroundStyle(accentColor.gradient)
                    .symbolEffect(.bounce, value: step.id)
            }
            
                // Localized Text Content
            VStack(spacing: 16) {
                Text(LocalizedStringKey(step.titleKey))
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                
                Text(LocalizedStringKey(step.subtitleKey))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
    // MARK: - Clean Architecture Factory & Previews
extension OnboardingView {
    static func build(coordinator: OnboardingCoordinating? = nil) -> OnboardingView {
        let repository = OnboardingRepositoryImpl()
        let viewModel = OnboardingViewModel(
            getStepsUseCase: GetOnboardingStepsUseCase(repository: repository),
            completeOnboardingUseCase: CompleteOnboardingUseCase(repository: repository),
            coordinator: coordinator
        )
        return OnboardingView(viewModel: viewModel)
    }
}

#Preview() {
    let repository = OnboardingRepositoryImpl()
    let viewModel = OnboardingViewModel(
        getStepsUseCase: GetOnboardingStepsUseCase(repository: repository),
        completeOnboardingUseCase: CompleteOnboardingUseCase(repository: repository)
    )
    OnboardingView(viewModel: viewModel)
        .environment(\.locale, Locale(identifier: "en"))
        .environment(\.layoutDirection, .leftToRight)
        .preferredColorScheme(.light)
}

#Preview("Arabic (RTL) - Dark") {
    let repository = OnboardingRepositoryImpl()
    let viewModel = OnboardingViewModel(
        getStepsUseCase: GetOnboardingStepsUseCase(repository: repository),
        completeOnboardingUseCase: CompleteOnboardingUseCase(repository: repository)
    )
    OnboardingView(viewModel: viewModel)
        .environment(\.locale, Locale(identifier: "ar"))
        .environment(\.layoutDirection, .rightToLeft)
        .preferredColorScheme(.dark)
}

