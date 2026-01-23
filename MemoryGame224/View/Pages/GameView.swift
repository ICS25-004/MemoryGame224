import SwiftUI

struct GameView: View {
		//Current SElection index
		@Binding var selectedSuitIndex: Int
		@Binding var suits: [Suit]
		

		var body: some View {
			ZStack {
					TabView(selection: $selectedSuitIndex) {
						
							ForEach(suits.indices, id: \.self) { index in
								SuitCardView(suit: $suits[index])
							}
					}
					.tabViewStyle(.page(indexDisplayMode: .always))
					.accessibilityIdentifier("GameView_TabViewPages")
					.ignoresSafeArea()

					TabButtonsView(selection: $selectedSuitIndex, lowerBound: 0, upperBound: suits.count - 1)
							.padding(.horizontal, 24)
							.padding(.vertical, 50)
							.ignoresSafeArea(edges: .bottom)
			}
		}
}
