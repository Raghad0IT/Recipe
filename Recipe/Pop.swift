//
//  Pop.swift
//  Recipe
//
//  Created by Raghad on 25/04/1446 AH.
//

import SwiftUI
struct Pop: View {
    @Binding var showPopup: Bool
    @Binding var ingredientName: String
    @Binding var quantity: Int
    @Binding var quantityType: String

    var body: some View {
        VStack {
            Text("Ingredient Name")
                .font(.headline)
                .padding()
            
            TextField("Ingredient Name", text: $ingredientName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...100)
                .padding()

            Button("Cancel") {
                showPopup = false
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(width: 300, height: 250)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

