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

    var body: some View {
        HStack {
            Button {
                if selection == lowerBound {
                    selection = upperBound
                } else {
                    selection = selection - 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
            }
            .accessibilityIdentifier("NavigationChevrons_LeftButton")
            
            Spacer()

            Button {
                if selection == upperBound {
                    selection = lowerBound
                } else {
                    selection = selection + 1
                }
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
