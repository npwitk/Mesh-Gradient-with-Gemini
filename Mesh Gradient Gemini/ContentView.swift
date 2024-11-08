//
//  ContentView.swift
//  Mesh Gradient Gemini
//
//  Created by Nonprawich I. on 02/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ColorViewModel()
    
    var body: some View {
        VStack {
            
            if !viewModel.lastPrompt.isEmpty {
                Text("Your Prompt: \(viewModel.lastPrompt)")
                    .padding(.top)
                    .foregroundColor(.primary)
                    .font(.headline)
            }
            
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                ],
                colors: [
                    viewModel.firstColor, viewModel.secondColor,
                    viewModel.thirdColor, viewModel.fourthColor,
                    viewModel.fifthColor, viewModel.sixthColor,
                    viewModel.seventhColor, viewModel.eighthColor,
                    viewModel.ninethColor
                ]
            )
            .cornerRadius(20)
            .padding()
            
            HStack {
                TextField("Enter your prompt here...", text: $viewModel.promptText)
                    .textFieldStyle(.roundedBorder)
                
                Button("Submit") {
                    Task {
                        await viewModel.submitPrompt()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.promptText.isEmpty || viewModel.isLoading)
            }
            .padding([.bottom, .horizontal])
            
            if viewModel.isLoading {
                ProgressView("Generating colors...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
            
            //            if !viewModel.responseText.isEmpty {
            //                ScrollView {
            //                    Text("AI Response: \(viewModel.responseText)")
            //                        .padding()
            //                        .foregroundColor(.gray)
            //                        .multilineTextAlignment(.leading)
            //                }
            //
            //            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
