//
//  ContentView.swift
//  MemoryGame226
//
//  Created by Caleb on 2026-01-05.
//

import SwiftUI

struct ContentView: View {
    private let suits: [String] = ["heart", "suit.spade", "suit.club", "diamond"]
    @State private var activeSuit = 2

    private var suitColor: Color {
        let name = suits[activeSuit]
        return (name == "diamond" || name == "heart") ? .red : .black
    }

    var body: some View {
        VStack {
            HStack{
                Image(systemName: "arrowtriangle.left")
                    .resizable()
                    .foregroundStyle(.tint)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        activeSuit = (activeSuit - 1 + suits.count) % suits.count
                    }
                VStack {
                    Image(systemName: suits[activeSuit])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(suitColor)
                        .padding(.bottom, 50)
                    
                    Text(suits[activeSuit].capitalized)
                        .frame(width: 200)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(suitColor)
                        .lineLimit(1)
                }.padding(25)
                Image(systemName: "arrowtriangle.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        activeSuit = (activeSuit + 1) % suits.count
                        
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

