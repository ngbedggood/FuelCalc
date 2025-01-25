//
//  CustomButton.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import SwiftUI

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            
            let offset: CGFloat = 5
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.buttonColorSecondary)
                .offset(y: offset)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.button)
                .offset(y: configuration.isPressed ? offset: 0)
            
            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    Button("Test") {
        
    }
    .foregroundColor(.white)
    .frame(width: 50, height: 50)
    .buttonStyle(CustomButton())
}
