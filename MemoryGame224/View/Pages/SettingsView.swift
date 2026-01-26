//
//  SettingsView.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-12.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage("rows") private var rows = 5
	@AppStorage("columns") private var columns = 5
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

			SettingsSuitPickerView(suits: $suits, selectedSuitIndex: $selectedSuitIndex)
			Group {
				Stepper(value: $rows, in: 1...10) {
					Text("Rows: \( rows)")
				}
				.accessibilityIdentifier("RowStepper")
				
				Stepper(value:  $columns, in:   1...10) {
					Text("Columns: \( columns)")
				}
				.accessibilityIdentifier("ColumnStepper")
			}

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
