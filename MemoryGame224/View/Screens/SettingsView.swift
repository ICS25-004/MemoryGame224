import SwiftUI

/// Displays the settings screen for configuring game parameters.
///
/// Allows users to select the board size, treasure suit, and whether to include a bonus tile.
/// All settings are persisted using AppStorage and automatically update the game board.
struct SettingsView: View {
	/// The board size (n x n) stored in UserDefaults.
	///
	/// Valid range is 5-10. Changes trigger board reinitialization.
	@AppStorage("rows") private var rowsAndColumns = 5
	
	/// Whether the board includes a bonus tile, stored in UserDefaults.
	///
	/// Changes trigger board reinitialization.
	@AppStorage("hasBonus") private var hasBonusTile: Bool = false
	
	/// The index of the currently selected suit in the suits array.
	///
	/// Bound to parent view to maintain selection across navigation.
	@Binding var selectedSuitIndex: Int
	
	/// The currently selected suit for treasure icons.
	///
	/// Safely accesses Suit.allCases using the selected index, clamping to valid range.
	private var selectedSuit: Suit {
		let suits = Array(Suit.allCases)
		return suits[min(max(selectedSuitIndex, 0), suits.count - 1)]
	}
	
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
			
			SuitCarousel(selectedSuitIndex: $selectedSuitIndex)
			Group {
				Stepper(value: $rowsAndColumns, in: 5...10) {
					Text("Rows & Columns: \(rowsAndColumns)")
				}
				.accessibilityIdentifier("rowsAndColumnsStepper")
			}
			
			Toggle(
				"Bonus Tile",
				systemImage: Suit.bonusIconName,
				isOn: $hasBonusTile
			)
			.tint(Suit.bonusColor)
			.foregroundStyle(hasBonusTile ? Suit.bonusColor : .primary)
			.animation(.spring, value: hasBonusTile)
			.symbolEffect(.bounce, value: hasBonusTile)
			.onTapGesture {
				hasBonusTile.toggle()
			}
			.accessibilityValue(hasBonusTile ? "On" : "Off")
			.accessibilityIdentifier("BonusTileToggle")
			
		}
		.padding()
	}
}
