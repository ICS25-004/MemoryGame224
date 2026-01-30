//
//  SettingsView.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-12.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("rows") private var rowsAndColumns = 5
	
	@AppStorage("hasBonusTile") private var hasBonusTile: Bool = false
		
	@Binding var selectedSuitIndex: Int
	@Binding var suits : [Suit]

	//1. Get the max (make sure not to go out of bounds zero)
	//2. Get the min (make sure not to go out of bounds count - 1)
	private var selectedSuit: Suit { suits[min(max(selectedSuitIndex, 0), suits.count - 1)] }
	
	var body: some View {
		VStack(spacing: 20) {
			Image(systemName: selectedSuit.iconName)
				.resizable()
				.scaledToFit()
				.frame(width: 80, height: 80)
				.foregroundStyle(selectedSuit.color)
				.frame(width: 200, height: 300)
				.background(
					RoundedRectangle(cornerRadius: 16)
						.fill(.white)
						.shadow(color: .gray, radius: 10)
				)
				.padding(.bottom, 30)

			SettingsImagePickerFull(suits: $suits, selectedSuitIndex: $selectedSuitIndex)
			Group {
				Stepper(value: $rowsAndColumns, in: 1...10) {
					Text("Rows & Columns: \(rowsAndColumns)")
				}
				.accessibilityIdentifier("rowsAndColumnsStepper")
			}
				
			// Wrap Toggle in HStack to make it tappable as a button
			HStack {
				Image(systemName: "star.hexagon.fill")
					.foregroundStyle(.tint)
				Text("Bonus Tile")
				Spacer()
				Toggle("", isOn: $hasBonusTile)
					.labelsHidden()
			}
			.contentShape(Rectangle())
			.onTapGesture {
				hasBonusTile.toggle()
			}
			.accessibilityElement(children: .combine)
			.accessibilityAddTraits(.isButton)
			.accessibilityLabel("Bonus Tile")
			.accessibilityValue(hasBonusTile ? "On" : "Off")
			.accessibilityIdentifier("BonusTileToggle")

		}
		.padding()
	}
}
