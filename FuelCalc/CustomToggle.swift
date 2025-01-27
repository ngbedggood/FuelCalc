//
//  CustomToggle.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 26/01/2025.
//

import SwiftUI

struct CustomToggle: ToggleStyle {

    let firstLabel: String
    let secondLabel: String
    let width: CGFloat

    func makeBody(configuration: Configuration) -> some View {

        let quarter = width / 4
        let half = width / 2

        RoundedRectangle(cornerRadius: 8)
            .stroke(.darkGray, lineWidth: 4)
            .fill(.gray)  //.brightness(-0.2)
            .frame(width: width, height: 33)
            .offset(y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .frame(width: width, height: 30)
                    .offset(y: 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue).brightness(-0.3)
                            .frame(width: half + 4, height: 32)
                            .offset(
                                x: configuration.isOn ? -quarter : quarter, y: 5
                            )

                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                            .frame(width: half + 4, height: 32)
                            .offset(x: configuration.isOn ? -quarter : quarter)
                        Text("\(firstLabel)")
                            .offset(x: -quarter)
                            .foregroundColor(
                                configuration.isOn ? .white : .darkGray)
                        Text("\(secondLabel)")
                            .offset(x: quarter)
                            .foregroundColor(
                                configuration.isOn ? .darkGray : .white)
                    }
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.2)) {
                            configuration.isOn.toggle()
                        }
                    }
            }
            .fontWeight(.bold)
    }
}

#Preview {

    Toggle("test", isOn: .constant(true))
        .toggleStyle(
            CustomToggle(
                firstLabel: "Label 1", secondLabel: "Label 2", width: 160))
}
