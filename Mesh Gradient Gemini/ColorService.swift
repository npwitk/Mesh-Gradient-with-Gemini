//
//  ColorService.swift
//  Mesh Gradient Gemini
//
//  Created by Nonprawich I. on 02/11/2024.
//

import Foundation
import FirebaseVertexAI

class ColorService {
    private let vertex = VertexAI.vertexAI()
    private let model: GenerativeModel
    
    init() {
        self.model = vertex.generativeModel(modelName: "gemini-1.5-flash")
    }
    
    func generateColors(for prompt: String) async throws -> String {
        let formattedPrompt = """
        Generate nine (9) distinct RGB color values for a mesh gradient based on the following prompt: "\(prompt)". 
        The output should be in the format: RGB(000, 000, 255), RGB(000, 000, 255), RGB(000, 000, 255), RGB(000, 000, 255).
        Ensure all RGB values are different.
        """
        
        let response = try await model.generateContent(formattedPrompt)
        return response.text ?? "I apologize, but I couldn't generate a response at the moment. Please try again."
    }
}
