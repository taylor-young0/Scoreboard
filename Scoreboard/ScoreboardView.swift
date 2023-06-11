//
//  ScoreboardView.swift
//  Scoreboard
//
//  Created by Taylor Young on 2023-06-03.
//

import SwiftUI

struct ScoreboardView: View {
    @EnvironmentObject var viewModel: ScoreboardViewModel

    var body: some View {
        let firstScoreSwipeGesture = DragGesture(minimumDistance: viewModel.minimumSwipeDistance, coordinateSpace: .global)
            .onEnded { value in
                viewModel.handleSwipe(with: value.translation, for: .firstScore)
            }

        let secondScoreSwipeGesture = DragGesture(minimumDistance: viewModel.minimumSwipeDistance, coordinateSpace: .global)
            .onEnded { value in
                viewModel.handleSwipe(with: value.translation, for: .secondScore)
            }

        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                viewModel.firstColor
                    .overlay {
                        firstScoreView
                            .contextMenu {
                                Button {
                                    viewModel.editScore(.firstScore)
                                } label: {
                                    editScoreView
                                }
                            }
                    }
                    .gesture(firstScoreSwipeGesture)
                viewModel.secondColor
                    .overlay {
                        secondScoreView
                            .contextMenu {
                                Button {
                                    viewModel.editScore(.secondScore)
                                } label: {
                                    editScoreView
                                }
                            }
                    }
                    .gesture(secondScoreSwipeGesture)
            }
            .edgesIgnoringSafeArea(.all)

            #if os(iOS)
            Button {
                viewModel.showingSettings.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundColor(viewModel.firstColor)
                    .padding(.trailing, 25)
                    .padding(.top, 10)
            }
            #endif
        }
        .sheet(isPresented: $viewModel.showingSettings) {
            SettingsView()
        }
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

    var editScoreView: some View {
        Label("Edit score", systemImage: "square.and.pencil")
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
