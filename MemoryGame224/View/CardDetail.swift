//
//  CardDetail.swift
//  MemoryGame224
//
//  Created by Caleb on 2026-01-08.
//

import SwiftUI

struct CardDetail: View {
	var body: some View {
		TabView {
			ForEach(Suit.allCases, id: \.self) { suit in
				VStack{
					Image(systemName: suit.iconName)
						.resizable()
						.scaledToFit()
						.frame(width: 100)
						.foregroundColor(suit.color)
					
					Text(suit.title)
						.font(Font.custom("Monocraft", size: 32))
						.foregroundColor(suit.color)
				}
			}
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.ignoresSafeArea()
	}
}

#Preview {
	CardDetail()
}
	
