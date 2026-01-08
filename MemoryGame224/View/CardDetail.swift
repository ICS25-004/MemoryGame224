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
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.white)
                        .shadow(radius: 7)
                        
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
                    .padding(.top, 30)
                }
                .padding(35)
                .background(Color.accentColor)
            }
        }
        .tabViewStyle(
            .page(indexDisplayMode: .always)
        )
        .ignoresSafeArea()
        .padding(.vertical, 50)
        
    }
}

#Preview {
    CardDetail()
}

