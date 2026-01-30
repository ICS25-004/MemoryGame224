import SwiftUI

struct GameView: View {
	@State var board = Board(size: 6, treasure: "star.fill")
	@Binding var selectedSuitIndex: Int
	@Binding var suits: [Suit]
	
	@State private var treasuresVisible = true
	@State private var countdown = 4
	
	
	var body: some View {
		//			ZStack {
		//					TabView(selection: $selectedSuitIndex) {
		//
		//							ForEach(suits.indices, id: \.self) { index in
		//								SuitCardView(suit: $suits[index])
		//							}
		//					}
		//					.tabViewStyle(.page(indexDisplayMode: .always)) //Each swipe tab gets own page
		//					.ignoresSafeArea() //Expand safe area of view
		//					.accessibilityIdentifier("GameView_TabViewPages")
		//
		//
		//					GameTabButtonsView(selection: $selectedSuitIndex, lowerBound: 0, upperBound: suits.count - 1)
		//							.padding(.horizontal, 10)
		//							.ignoresSafeArea(edges: .bottom)
		VStack {
			//			ForEach(board!.tiles, id:\.first!.id) { row in
			//				HStack {
			//					ForEach(row, id: \.id) { tile in
			//						Button {
			//							// Action
			//						} label: {
			//							Image(systemName: board!.treasure)
			//								.font(.largeTitle)
			//						}
			//					}
			//				}
			//			}
			Spacer()
			Grid {
				ForEach(board!.tiles, id:\.first!.id) { row in
					GridRow {
						ForEach(row, id: \.id) { tile in
							Button {

							} label: {
								Image(systemName: tile.contents)
									.font(.largeTitle)
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
					}
				}
			}
			.frame(maxHeight: .infinity)
		}
	}
}

