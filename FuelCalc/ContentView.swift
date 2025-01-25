//
//  ContentView.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var fuelVolume: Double = 0.0
    @State private var distance: Double = 0.0
    @State private var isLitres: Bool = true
    @State private var isKilometers: Bool = true
    
    @State private var isMetricResult: Bool = true
    @State private var result: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Fuel Economy Calculator")
                .font(.title)
            
            HStack {
                TextField("Volume", value: $fuelVolume, format: .number)
                    .textFieldStyle(.roundedBorder)
                Button() {
                    isLitres.toggle()
                } label: {
                    Text(isLitres ? "L" : "Gal")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            HStack {
                TextField("Distance", value: $distance, format: .number)
                    .textFieldStyle(.roundedBorder)
                Button() {
                    isKilometers.toggle()
                } label: {
                    Text(isKilometers ? "Km" : "Miles")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            Text("\(calcResult(fuelVolume: fuelVolume, distance: distance))")
            Button() {
                isMetricResult.toggle()
            } label: {
                Text(isMetricResult ? "L / 100km" : "MPG")
            }
            .buttonStyle(.borderedProminent)
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
        return isMetricResult ? result : result * 2.352
        
    }
    
    
}

#Preview {
    ContentView()
}
