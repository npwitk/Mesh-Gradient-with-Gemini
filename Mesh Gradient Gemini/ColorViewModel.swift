//
//  ColorViewModel.swift
//  Mesh Gradient Gemini
//
//  Created by Nonprawich I. on 02/11/2024.
//

import Foundation
import FirebaseVertexAI
import SwiftUI

@MainActor
class ColorViewModel: ObservableObject {
    @Published var firstColor: Color = .red
    @Published var secondColor: Color = .orange
    @Published var thirdColor: Color = .purple
    @Published var fourthColor: Color = .blue
    @Published var promptText: String = ""
    @Published var lastPrompt: String = ""
    @Published var responseText: String = ""
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    private let colorService = ColorService()
    
    func submitPrompt() async {
        guard !promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        responseText = ""
        lastPrompt = promptText
        
        do {
            let response = try await colorService.generateColors(for: promptText)
            responseText = response
            
            let rgbPattern = #"RGB\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)"#
            let regex = try NSRegularExpression(pattern: rgbPattern, options: .caseInsensitive)
            let range = NSRange(response.startIndex..<response.endIndex, in: response)
            let matches = regex.matches(in: response, options: [], range: range)
            
            guard matches.count == 4 else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid color format received"])
            }
            
            let colors = matches.map { match -> Color in
                let components = (1...3).map { componentIndex -> Int in
                    let range = match.range(at: componentIndex)
                    let component = (response as NSString).substring(with: range)
                    return Int(component) ?? 0
                }
                return Color(
                    red: Double(components[0]) / 255.0,
                    green: Double(components[1]) / 255.0,
                    blue: Double(components[2]) / 255.0
                )
            }
            
            firstColor = colors[0]
            secondColor = colors[1]
            thirdColor = colors[2]
            fourthColor = colors[3]
            
            promptText = ""
        } catch {
            self.error = "Failed to get colors: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
