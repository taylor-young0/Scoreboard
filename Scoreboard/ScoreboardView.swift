//
//  ScoreboardView.swift
//  Scoreboard
//
//  Created by Taylor Young on 2023-06-03.
//

import SwiftUI

struct ScoreboardView: View {
    @EnvironmentObject var viewModel: ScoreboardViewModel

    var minimumSwipeDistance: CGFloat {
        #if os(iOS)
            return 100
        #elseif os(watchOS)
            return 50
        #endif
    }

    var body: some View {
        let firstScoreSwipeGesture = DragGesture(minimumDistance: minimumSwipeDistance, coordinateSpace: .global)
            .onEnded { value in
                viewModel.handleSwipe(with: value.translation, for: .firstScore)
            }

        let secondScoreSwipeGesture = DragGesture(minimumDistance: minimumSwipeDistance, coordinateSpace: .global)
            .onEnded { value in
                viewModel.handleSwipe(with: value.translation, for: .secondScore)
            }

        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                Color.cyan
                    .overlay {
                        firstScoreView
                    }
                    .gesture(firstScoreSwipeGesture)
                Color.white
                    .overlay {
                        secondScoreView
                    }
                    .gesture(secondScoreSwipeGesture)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    var firstScoreView: some View {
        ScoreTextView(score: viewModel.firstScore, color: viewModel.secondColor)
    }

    var secondScoreView: some View {
        ScoreTextView(score: viewModel.secondScore, color: viewModel.firstColor)
    }

    struct ScoreTextView: View {
        var score: Int
        var color: Color

        var fontSize: CGFloat {
            #if os(iOS)
                return 100
            #elseif os(watchOS)
                return 50
            #endif
        }

        var body: some View {
            Text("\(score)")
                .font(.system(size: fontSize).bold())
                .monospacedDigit()
                .foregroundColor(color)
                .padding()
        }
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
            .environmentObject(ScoreboardViewModel())
        ScoreboardView()
            .previewInterfaceOrientation(.landscapeRight)
            .environmentObject(ScoreboardViewModel())
        ScoreboardView()
            .previewDevice("iPad (9th generation)")
            .environmentObject(ScoreboardViewModel())
    }
}
