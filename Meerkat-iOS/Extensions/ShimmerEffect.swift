//
//  ShimmerEffect.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI

extension View {
    func shimmerEffect(
        gradient: Gradient = ShimmerEffect.defaultGradient,
        animation: Animation =  ShimmerEffect.defaultAnimation,
        angle: Angle =  ShimmerEffect.defaultAngle
    ) -> some View {
        self.modifier(ShimmerEffect(gradient: gradient, animation: animation, angle: angle))
    }
}

struct ShimmerEffect: Animatable, ViewModifier {
    @State private var isAnimating: Bool = false
    
    private let animation: Animation
    private let gradient: Gradient
    private let angle: Angle
    private let min = -0.5
    private let max = 1.5
    
    
    public static let defaultGradient: Gradient = Gradient(colors: [.clear, .white.opacity(0.5), .clear])
    
    public static let defaultAnimation = Animation.linear(duration: 1.25).repeatForever(autoreverses: false)
    
    public static let defaultAngle = Angle.degrees(0.0)
    
    init(
        gradient: Gradient = Self.defaultGradient,
        animation: Animation = Self.defaultAnimation,
        angle: Angle = Self.defaultAngle
    ) {
        
        self.gradient = gradient
        self.animation = animation
        self.angle = angle
    }
    
    func body(content: Content) -> some View {
        content.overlay(content: {
            shimmerView
                .mask(content)
        })
    }
    
    var startPoint: UnitPoint {
        isAnimating ? UnitPoint(x: 1, y: 1) : UnitPoint(x: min, y: min)
    }
    var endPoint: UnitPoint {
        isAnimating ? UnitPoint(x: max, y: max) : UnitPoint(x: 0, y: 0)
    }
    
    var shimmerView: some View {
        LinearGradient(gradient: self.gradient, startPoint: startPoint , endPoint: endPoint)
            .rotationEffect(angle)
            .scaleEffect(1.5)
            .clipped()
            .animation(animation, value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    HStack {
        Circle()
            .fill(.secondary)
            .frame(width: 50)
        VStack {
            Text("Lorem Ipsum")
            Text("Dolor sit")
                .foregroundStyle(.secondary)
        }
    }
    .redacted(reason: .placeholder)
    .shimmerEffect()
}
