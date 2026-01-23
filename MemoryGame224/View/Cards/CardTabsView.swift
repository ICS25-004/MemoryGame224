import SwiftUI

struct CardTabsView: View {
		// Track the currently selected tab by index
		@Binding var selectedSuitIndex: Int
		@Binding var suits: [Suit]
		

		var body: some View {
				ZStack {
						TabView(selection: $selectedSuitIndex) {
								ForEach(suits.indices) {
									SuitCardView(suit: $suits[$0])
								}
						}
						.tabViewStyle(.page(indexDisplayMode: .always))
						.ignoresSafeArea()

						GameTabButtonsView(
							selection: $selectedSuitIndex,
							lowerBound: 0,
							upperBound: suits.count - 1
						)
						.padding(.horizontal, 24)
						.padding(.vertical, 50)
						.ignoresSafeArea(edges: .bottom)
				}
		}
}
