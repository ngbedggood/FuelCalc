//
//  ContentView.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query var trips: [Trip]
    
    @FocusState var isInputActive: Bool
    
    @State private var fuelVolume: Float = 49.77
    @State private var distance: Float = 524.0
    @State private var isLitres: Bool = true
    @State private var isKilometers: Bool = true
    
    @State private var isMetricResult: Bool = true
    //@State private var result: Float
    
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
                        .focused($isInputActive)
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
                        .focused($isInputActive)
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
                let tempResult = calcResult(fuelVolume: fuelVolume, distance: distance)
                Text("\(isMetricResult ? tempResult : 235.2145/tempResult, specifier: "%.2f")")
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
                context.insert(Trip(
                    fuelVolume: fuelVolume,
                    distance: distance,
                    economy: calcResult(fuelVolume: fuelVolume, distance: distance),
                    date: Date.now
                ))
                if (trips.count > 8) {
                    if (trips.last != nil) {
                        let trip = trips.last
                        context.delete(trip!)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } label: {
                Text("Save Trip")
            }
            .buttonStyle(CustomButton(buttonColor: .gray))
            .frame(width: 100, height: 32)
            .padding()
            
            //List {
                Grid {
                    GridRow {
                        Text("Fuel")
                        Text("Distance")
                        Text("Economy")
                        Text("Date")
                    }
                    .bold()
                    Divider()
                    ForEach(trips, id: \.id) { trip in
                        GridRow {
                            Text("\(isMetricResult ? trip.fuelVolume : trip.fuelVolume / 3.78541, specifier: "%.2f")")
                            Text("\(isMetricResult ? trip.distance : trip.distance / 1.60934, specifier: "%.2f")")
                            Text("\(isMetricResult ? trip.economy : 235.2145 / trip.economy, specifier: "%.2f")")
                            Text("\(trip.date.formatted(date: .numeric, time: .omitted))")
                        }
                        if trip != trips.last {
                            Divider()
                        }
                    }
                }
            //}
            //.scrollDisabled(true)
            //.font(.subheadline)
            
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") {
                    isInputActive = false
                }
            }
        }
    }
    
    func calcResult(fuelVolume: Float, distance: Float) -> Float {
        var tempVolume = fuelVolume
        var tempDistance = distance
        if (!isLitres) {
            tempVolume *= 3.78541
        }
        if (!isKilometers) {
            tempDistance *= 1.60934
        }
        //let tempResult = (tempVolume / tempDistance) * 100
        return tempVolume / tempDistance * 100//isMetricResult ? tempResult : 235.2145 / tempResult
        
    }
    
    private func deleteTrip(indexSet: IndexSet) {
            indexSet.forEach { index in
                let trip = trips[index]
                context.delete(trip)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    
    
}

#Preview {
    ContentView()
}
