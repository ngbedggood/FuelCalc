//
//  ContentView.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Trip.date, order: .reverse) var trips: [Trip]
    
    var formatter = NumberFormatter()
    
    
    @FocusState var isInputActive: Bool
    
    @State private var fuelVolume: Float = 0
    @State private var distance: Float = 0
    @State private var isLitres: Bool = true
    @State private var isKilometers: Bool = true
    
    @State private var isMetricResult: Bool = true
    //@State private var result: Float
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Fuel Economy Calculator")
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(.gray)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.top, .bottom], 16)
                    .foregroundColor(.white)
                
                VStack {
                    Text("How much fuel did you use?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    HStack {
                        ZStack {
                            TextField("", value: $fuelVolume, format: .number)
                                .frame(height: 33)
                                .keyboardType(.decimalPad)
                                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                                .background(.gray)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("darkGray"), lineWidth:2))
                                .foregroundStyle(.clear)
                                .accentColor(.clear)
                                .frame(width: 130)
                                .focused($isInputActive)
                                .simultaneousGesture(TapGesture().onEnded {
                                    fuelVolume = 0.0
                                })
                            Text("\(NSString(format: "%.2f",fuelVolume))")
                                .foregroundStyle(.white)
                                .font(.title2)
                        }
                        Toggle("", isOn: $isLitres)
                            .toggleStyle(CustomToggle(firstLabel: "Litres", secondLabel: "Gallons", width: 150))
                            .offset(y: -2)
                    }
                }
                .padding(8)
                
                VStack {
                    Text("How far did you travel?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    HStack {
                        ZStack {
                            TextField("", value: $distance, format: .number)
                                .frame(height: 33)
                                .keyboardType(.decimalPad)
                                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                                .background(.gray)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("darkGray"), lineWidth:2))
                                .foregroundStyle(.clear)
                                .accentColor(.clear)
                                .frame(width: 130)
                                .focused($isInputActive)
                                .simultaneousGesture(TapGesture().onEnded {
                                    distance = 0.0
                                })
                            Text("\(NSString(format: "%.2f",distance))")
                                .foregroundStyle(.white)
                                .font(.title2)
                        }
                        Toggle("Distance", isOn: $isKilometers)
                            .toggleStyle(CustomToggle(firstLabel: "Km", secondLabel: "Miles", width: 150))
                            .offset(y: -2)
                    }
                }
                .padding(8)
                
                HStack {
                    let tempResult = calcResult(fuelVolume: fuelVolume, distance: distance)
                    Text("\(isMetricResult ? tempResult : 235.2145/tempResult, specifier: "%.2f")")
                        .font(.title)
                        .frame(width: 100)

                    Toggle("Economy", isOn: $isMetricResult)
                        .toggleStyle(CustomToggle(firstLabel: "L/100Km", secondLabel: "MPG", width: 180))
                        .offset(y: -2)
                }
                .foregroundColor(.white)
                .padding(.top, 32)
                
                Button() {
                    if (calcResult(fuelVolume: fuelVolume, distance: distance).isFinite) {
                        context.insert(Trip(
                            fuelVolume: isLitres ? fuelVolume : fuelVolume * 3.78541,
                            distance: isKilometers ? distance : distance * 1.60934,
                            economy: calcResult(fuelVolume: fuelVolume, distance: distance),
                            date: Date.now
                        ))
                    }
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
                .frame(width: 100, height: 33)
                .padding()
                
                Grid(horizontalSpacing: 20) {
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
                .padding()
                .foregroundColor(.white)
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
        }
        .background(Color("appColor"))
        .scrollDisabled(true)
    }
    
    private func calcResult(fuelVolume: Float, distance: Float) -> Float {
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
