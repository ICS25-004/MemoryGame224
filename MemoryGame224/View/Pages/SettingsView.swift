//
//  SettingsView.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-12.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("rowRange") private var rows = 5
	@AppStorage("columnRange") private var columns = 5
	@AppStorage("hasBonusTile") private var hasBonusTile: Bool = false
	@AppStorage("showingSettings") private var showingSettings: Bool = true
	
	@Binding var selectedSuitIndex: Int
	@Binding var suits : [Suit]

	//Get the max (make sure not to go out of bounds zero)
	//Get the min (make sure not to go out of bounds count - 1)
	private var selectedSuit: Suit {
		suits[min(max(selectedSuitIndex, 0), suits.count - 1)]
	}
	
	var body: some View {
		VStack(spacing: 20) {
			Image(systemName: selectedSuit.iconName)
				.resizable()
				.scaledToFit()
				.frame(width: 80, height: 80)
				.padding(.top, 4)
				.foregroundStyle(selectedSuit.color)

			SuitPickerView(suits: $suits, selectedSuitIndex: $selectedSuitIndex)

			Stepper(value: $rows, in: 1...10) {
				Text("Rows: \( $rows)")
			}
			.accessibilityIdentifier("RowStepper")

			Stepper(value:  $columns, in:   1...10) {
				Text("Columns: \( $columns)")
			}
			.accessibilityIdentifier("ColumnStepper")

			HStack {
				Image(systemName: "star.hexagon.fill")
					.foregroundColor(.yellow)
				Toggle("Bonus Tile", isOn: $hasBonusTile)
					.accessibilityIdentifier("BonusTileToggle")
			}
		}
		.padding()
	}
}
