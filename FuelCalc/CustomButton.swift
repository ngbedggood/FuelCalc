//
//  CustomButton.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import SwiftUI

struct CustomButton: ButtonStyle {

    let buttonColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {

            let offset: CGFloat = 5

            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(buttonColor)
                .brightness(-0.3)
                .offset(y: offset)

            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(buttonColor)
                .offset(y: configuration.isPressed ? offset : 0)

            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
                .foregroundStyle(.white)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    Button("Test") {

    }
    .foregroundColor(.white)
    .frame(width: 50, height: 50)
    .buttonStyle(CustomButton(buttonColor: .red))
}
