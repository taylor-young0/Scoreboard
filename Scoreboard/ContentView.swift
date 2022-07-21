//
//  ContentView.swift
//  Scoreboard
//
//  Created by Taylor Young on 2022-06-30.
//

import SwiftUI

struct ContentView: View {
    @State var firstScore: Int = 0
    @State var secondScore: Int = 0

    var heightDivisor: CGFloat {
        switch UITraitCollection.current.horizontalSizeClass {
        case .compact:
            return 2.0
        case .regular:
            return 3.0
        default:
            return 3.0
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    Color.indigo
                    Color.orange
                }
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                        Text("Toronto Raptors")
                            .font(.custom("Trebuchet MS", size: 50))
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .minimumScaleFactor(0.5)
                            .padding()
                        Text("Toronto")
                            .font(.custom("Trebuchet MS", size: 50))
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .minimumScaleFactor(0.5)
                            .padding()
                        Text("\(firstScore)")
                            .font(.custom("Trebuchet MS", size: 200))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / heightDivisor)
                            .minimumScaleFactor(0.5)
                            .onTapGesture {
                                firstScore += 1
                            }
                        Text("\(secondScore)")
                            .font(.custom("Trebuchet MS", size: 200))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / heightDivisor)
                            .minimumScaleFactor(0.5)
                            .onTapGesture {
                                secondScore += 1
                            }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
        ContentView()
            .previewDevice("iPad (9th generation)")
        ContentView()
            .previewDevice("iPad (9th generation)")
            .previewInterfaceOrientation(.landscapeRight)
    }
}
