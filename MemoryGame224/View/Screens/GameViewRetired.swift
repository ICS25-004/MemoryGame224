import SwiftUI

struct GameViewRetired: View {
		//Current SElection index
		@Binding var selectedSuitIndex: Int
		@Binding var suits: [Suit]
		

		var body: some View {
			ZStack {
					TabView(selection: $selectedSuitIndex) {
						
							ForEach(suits.indices, id: \.self) { index in
								SuitDisplayCard(suit: $suits[index])
							}
					}
					.tabViewStyle(.page(indexDisplayMode: .always)) //Each swipe tab gets own page
					.ignoresSafeArea() //Expand safe area of view
					.accessibilityIdentifier("GameView_TabViewPages")
					

					NavigationChevrons(selection: $selectedSuitIndex, lowerBound: 0, upperBound: suits.count - 1)
							.padding(.horizontal, 10)
							.ignoresSafeArea(edges: .bottom)
			}
		}
}
