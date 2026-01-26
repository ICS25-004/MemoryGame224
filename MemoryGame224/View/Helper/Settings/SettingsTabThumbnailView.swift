//
//  SwiftUIView.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-19.
//

import SwiftUI

struct SettingsTabThumbnailView: View {
	let currentIndex: Int
	let currentSuit: Suit
	
	@Binding var selectedSuitIndex: Int

    var body: some View {
			Button(action: {
				selectedSuitIndex = currentIndex
			}) {
				VStack(spacing: 4) {
					Image(systemName: currentSuit.iconName)
						.frame(width: 44, height: 44)
						.foregroundStyle(currentSuit.color)
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(
									currentIndex == selectedSuitIndex ? Color.accentColor : Color.clear, lineWidth: 2
								)
						)
						.background(
							RoundedRectangle(cornerRadius: 8)
								.fill(Color.white)
						)
				}
			}
			.buttonStyle(.plain)
			.accessibilityAddTraits(.isButton)
			.accessibilityIdentifier("ThumbnailView_Icon_\(currentSuit.rawValue)")
    }
}
