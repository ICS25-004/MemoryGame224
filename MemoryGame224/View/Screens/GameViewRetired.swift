import SwiftUI

struct GameViewRetired: View {
		@Binding var selectedSuitIndex: Int
		@Binding var suits: [Suit]

		var body: some View {
			ZStack {
					TabView(selection: $selectedSuitIndex) {
						ForEach(suits.indices, id: \.self) {
							SuitDisplayCard(suit: $suits[$0])
						}
					}
					.tabViewStyle(.page(indexDisplayMode: .always))
					.ignoresSafeArea()
					.accessibilityIdentifier("GameView_TabViewPages")
					
					NavigationChevrons(selection: $selectedSuitIndex, lowerBound: 0, upperBound: suits.count - 1)
							.padding(.horizontal, 10)
							.ignoresSafeArea(edges: .bottom)
			}
		}
}
