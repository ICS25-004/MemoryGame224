import SwiftUI

/// Navigation control with left and right chevron buttons for cycling through items.
///
/// Provides wraparound navigation where selecting past the last item returns to the first,
/// and selecting before the first returns to the last. Useful for carousels and pickers.
struct NavigationChevrons: View {
    /// The currently selected item index.
    @Binding var selection: Int
    
    /// The minimum valid index (inclusive).
    let lowerBound: Int
    
    /// The maximum valid index (inclusive).
    let upperBound: Int

    // Reusable wraparound navigation closures
    private var increment: () -> Void { { selection = (selection == upperBound) ? lowerBound : selection + 1 } }

    private var decrement: () -> Void { { selection = (selection == lowerBound) ? upperBound : selection - 1 } }
    
    
    
    var body: some View {
        HStack {
            Button {
                decrement()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
            }
            .accessibilityIdentifier("NavigationChevrons_LeftButton")
            
            Spacer()

            Button {
                increment()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
            }
            .accessibilityIdentifier("NavigationChevrons_RightButton")
        }
    }
}

