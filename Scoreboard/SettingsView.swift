//
//  SettingsView.swift
//  Scoreboard
//
//  Created by Taylor Young on 2023-06-10.
//

import SwiftUI

struct SettingsView: View {
    enum FocusedField {
        case firstScore, secondScore
    }

    @EnvironmentObject var viewModel: ScoreboardViewModel
    @FocusState var focusedField: FocusedField?
    @State var showingAlert: Bool = false

    var body: some View {
        #if os(iOS)
        NavigationView {
            Form {
                Section("Colours") {
                    ColorPicker("First colour", selection: $viewModel.firstColor)
                    ColorPicker("Second colour", selection: $viewModel.secondColor)
                }

                Section("Edit Scores") {
                    HStack {
                        viewModel.firstColor
                            .overlay {
                                TextField("First score", value: $viewModel.firstScore, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .firstScore)
                                    .padding()
                            }
                        viewModel.secondColor
                            .overlay {
                                TextField("Second score", value: $viewModel.secondScore, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .secondScore)
                                    .padding()
                            }
                    }
                    .cornerRadius(10)
                    .keyboardType(.numberPad)
                    .frame(height: 200)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary)
                    }

                    Button("Reset scores", role: .destructive) {
                        showingAlert.toggle()
                    }
                }
            }
            .navigationTitle(Text("Settings"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        viewModel.showingSettings.toggle()
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .alert("Reset scores", isPresented: $showingAlert) {
                Button("Yes, reset scores", role: .destructive) {
                    viewModel.resetScores()
                }
            } message: {
                Text("Are you sure you want to reset scores? Both scores will be reset to 0.")
            }

        }
        #endif
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ScoreboardViewModel())
    }
}
