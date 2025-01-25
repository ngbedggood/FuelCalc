//
//  ContentView.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var fuelVolume: Double = 49.7
    @State private var distance: Double = 524.0
    @State private var isLitres: Bool = true
    @State private var isKilometers: Bool = true
    
    @State private var isMetricResult: Bool = true
    @State private var result: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Fuel Economy Calculator")
                .font(.title)
                .padding(.bottom, 50)
            
            VStack {
                Text("How much fuel did you use?")
                    .font(.subheadline)
                HStack {
                    TextField("Volume", value: $fuelVolume, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Button() {
                        isLitres.toggle()
                    } label: {
                        Text(isLitres ? "L" : "Gal")
                    }
                    .buttonStyle(CustomButton(buttonColor: .blue))
                    .frame(width: 60, height: 32)
                }
            }
            .padding()
            
            VStack {
                Text("How far did you travel?")
                    .font(.subheadline)
                HStack {
                    TextField("Distance", value: $distance, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    Button() {
                        isKilometers.toggle()
                    } label: {
                        Text(isKilometers ? "Km" : "Miles")
                    }
                    .buttonStyle(CustomButton(buttonColor: .blue))
                    .frame(width: 60, height: 32)
                }
            }
            .padding()
            
            HStack {
                Text("\(calcResult(fuelVolume: fuelVolume, distance: distance), specifier: "%.2f")")
                    .font(.title)
                    .frame(width: 100)
                Button() {
                    isMetricResult.toggle()
                } label: {
                    Text(isMetricResult ? "L / 100km" : "MPG")
                }
                .buttonStyle(CustomButton(buttonColor: .blue))
                .frame(width: 100, height: 32)
            }
            .padding(.top, 50)
            
            Button() {
                
            } label: {
                Text("Save Trip")
            }
            .buttonStyle(CustomButton(buttonColor: .gray))
            .frame(width: 100, height: 32)
            .padding()
            
            
        }
        .padding()
    }
    
    func calcResult(fuelVolume: Double, distance: Double) -> Double {
        var tempVolume = fuelVolume
        var tempDistance = distance
        if (!isLitres) {
            tempVolume *= 3.78541
        }
        if (!isKilometers) {
            tempDistance *= 1.60934
        }
        let result = (tempVolume / tempDistance) * 100
        return isMetricResult ? result : 235.2145 / result
        
    }
    
    
}

#Preview {
    ContentView()
}
