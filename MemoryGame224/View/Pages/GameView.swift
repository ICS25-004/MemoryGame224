import SwiftUI
import Combine

/// The main game view displaying the memory game board
struct GameView: View {
	@AppStorage("rows") private var rowsAndColumns = 5
	@AppStorage("hasBonusTile") private var hasBonusTile: Bool = false
	
	@Binding var selectedSuitIndex: Int
	@Binding var suits: [Suit]
	
	@State private var board: Board?
	@State private var treasuresVisible = true
	@State private var tapCount: Int = 0
	@State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State private var elapsedTime: Int = 0
	
	/// The currently selected suit for treasure icons
	private var selectedSuit: Suit { 
		suits[min(max(selectedSuitIndex, 0), suits.count - 1)] 
	}
	
	var body: some View {
		VStack {
			// Timer display
			if treasuresVisible {
				Text("\(max(0, 4 - elapsedTime))")
					.font(.system(size: 60, weight: .bold, design: .rounded))
					.foregroundStyle(.orange)
					.contentTransition(.numericText())
					.padding(.top)
			} else {
				Text("Go!")
					.font(.system(size: 60, weight: .bold, design: .rounded))
					.foregroundStyle(.green)
					.padding(.top)
			}
			
			Grid {
				if let board = board {
					ForEach(board.tiles, id: \.first!.id) { row in
						GridRow {
							ForEach(row, id: \.id) { tile in
								Button {
									handleTileTap(tile)
								} label: {
									Image(systemName: getTileImageName(for: tile))
										.font(.largeTitle)
										.foregroundStyle(getTileColor(for: tile))
								}
								.frame(maxWidth: .infinity, maxHeight: .infinity)
							}
						}
					}
				}
			}
			.frame(maxHeight: .infinity)
			
			Spacer()
			
			HStack {
				Group {
					Text("Tap Count: \(tapCount)")
					Text("Treasure Count: \(board?.countUnrevealedTreasures() ?? 0)")
				}
				.padding()
				.background(Color.accentColor, in: Capsule())
				.glassEffect()
			}
		}
		.onAppear {
			initializeBoard()
		}
		.onChange(of: rowsAndColumns) {
			initializeBoard()
		}
		.onChange(of: selectedSuit) {
			initializeBoard()
		}
		.onChange(of: hasBonusTile) {
			initializeBoard()
		}
		.onReceive(timer) { _ in
			if treasuresVisible {
				elapsedTime += 1
				if elapsedTime >= 4 {
					treasuresVisible = false
					timer.upstream.connect().cancel()
				}
			}
		}
	}
	
	/// Initializes or resets the game board
	private func initializeBoard() {
		board = Board(size: rowsAndColumns, treasure: selectedSuit.iconName, hasBonus: hasBonusTile)
		treasuresVisible = true
		tapCount = 0
		elapsedTime = 0
		timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	}
	
	/// Handles tap events on tiles
	/// - Parameter tile: The tile that was tapped
	private func handleTileTap(_ tile: Tile) {
		guard !treasuresVisible else { return }
		
		if !tile.isRevealed {
			tile.isRevealed = true
			
			if tile.isBonus && !tile.bonusUsed {
				tile.bonusUsed = true
				tapCount = 0
			} else {
				tapCount += 1
			}
		}
	}
	
	/// Returns the appropriate image name for a tile based on its state
	/// - Parameter tile: The tile to get the image name for
	/// - Returns: The system image name to display
	private func getTileImageName(for tile: Tile) -> String {
		if treasuresVisible || tile.isRevealed {
			return tile.contents
		}
		return "questionmark.app"
	}
	
	/// Returns the appropriate color for a tile based on its content
	/// - Parameter tile: The tile to get the color for
	/// - Returns: The color to apply to the tile icon
	private func getTileColor(for tile: Tile) -> Color {
		if (treasuresVisible || tile.isRevealed) && tile.contents == selectedSuit.iconName {
			return selectedSuit.color
		}
		return .primary
	}
}

