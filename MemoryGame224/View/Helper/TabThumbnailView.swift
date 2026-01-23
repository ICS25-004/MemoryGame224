//
//  SwiftUIView.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-19.
//

import SwiftUI

struct TabThumbnailView: View {
	@State var currentIndex: Int
	@State var currentSuit: Suit
	
	@Binding var selectedSuitIndex: Int

    var body: some View {
				return VStack(spacing: 4) {
					Image(systemName: currentSuit.iconName)
						.frame(width: 44, height: 44)
						.contentShape(Rectangle())
						.foregroundStyle(currentSuit.color)
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(currentIndex == selectedSuitIndex ? currentSuit.color : Color.clear, lineWidth: 2)
						)
						.background(
							RoundedRectangle(cornerRadius: 8)
								.fill(Color.white)
						)
						.accessibilityIdentifier("ThumbnailView_Icon_\(currentIndex)")
						.onTapGesture { selectedSuitIndex = currentIndex }
				}
    }
}
