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
    
    func makeBody(configuration: Configuration) -> some View {
        
        RoundedRectangle(cornerRadius: 8)
            .stroke(.darkGray, lineWidth: 4)
            .fill(.gray)//.brightness(-0.2)
            .frame(width: 160, height: 33)
            .offset(y:3)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .frame(width: 160, height: 30)
                    .offset(y: 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue).brightness(-0.3)
                            .frame(width: 84, height: 32)
                            .offset(x: configuration.isOn ? -40 : 40, y: 5)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                            .frame(width: 84, height: 32)
                            .offset(x: configuration.isOn ? -40 : 40)
                        Text("\(firstLabel)")
                            .offset(x: -40)
                            .foregroundColor(configuration.isOn ? .white : .darkGray)
                        Text("\(secondLabel)")
                            .offset(x: 40)
                            .foregroundColor(configuration.isOn ? .darkGray : .white)
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
        .toggleStyle(CustomToggle(firstLabel: "Label 1", secondLabel: "Label 2"))
}
