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
    @Query(sort: \Trip.date, order: .reverse) var trips: [Trip]
    
    @FocusState var isInputActive: Bool
    
    @State private var fuelVolume: Float = 1
    @State private var distance: Float = 100
    @State private var isLitres: Bool = true
    @State private var isKilometers: Bool = true
    
    @State private var isMetricResult: Bool = true
    //@State private var result: Float
    
    var body: some View {
        VStack {
            Text("Fuel Economy Calculator")
                .frame(maxWidth: .infinity, maxHeight: 50)
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
                    TextField("Volume", value: $fuelVolume, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .background(.gray)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("darkGray"), lineWidth:2))
                        .foregroundStyle(.white)
                        .focused($isInputActive)
                        .font(.title)
                        .frame(width: 130)
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                                // Click to select all the text.
                                if let textField = obj.object as? UITextField {
                                    textField.selectAll(nil)
                                }
                            }
                    /*Button() {
                        isLitres.toggle()
                    } label: {
                        Text(isLitres ? "L" : "Gal")
                    }
                    .buttonStyle(CustomButton(buttonColor: .blue))
                    .frame(width: 60, height: 33)
                    .offset(y: -3)
                    */
                    Toggle("Fuel", isOn: $isLitres)
                        .toggleStyle(CustomToggle(firstLabel: "Litres", secondLabel: "Gallons"))
                        .offset(y: -2)
                }
            }
            .padding(8)
            
            VStack {
                Text("How far did you travel?")
                    .font(.subheadline)
                    .foregroundColor(.white)
                HStack {
                    TextField("Distance", value: $distance, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .background(.gray)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("darkGray"), lineWidth:2))
                        .foregroundStyle(.white)
                        .focused($isInputActive)
                        .font(.title)
                        .frame(width: 130)
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                                // Click to select all the text.
                                if let textField = obj.object as? UITextField {
                                    textField.selectAll(nil)
                                }
                            }
                    /*Button() {
                        isKilometers.toggle()
                    } label: {
                        Text(isKilometers ? "Km" : "Miles")
                    }
                    .buttonStyle(CustomButton(buttonColor: .blue))
                    .frame(width: 60, height: 33)
                    .offset(y: -3)
                     */
                    Toggle("Distance", isOn: $isKilometers)
                        .toggleStyle(CustomToggle(firstLabel: "Km", secondLabel: "Miles"))
                        .offset(y: -2)
                }
            }
            .padding(8)
            
            HStack {
                let tempResult = calcResult(fuelVolume: fuelVolume, distance: distance)
                Text("\(isMetricResult ? tempResult : 235.2145/tempResult, specifier: "%.2f")")
                    .font(.title)
                    .frame(width: 100)
                
                /*Button() {
                    isMetricResult.toggle()
                } label: {
                    Text(isMetricResult ? "L / 100km" : "MPG")
                }
                .buttonStyle(CustomButton(buttonColor: .blue))
                .frame(width: 100, height: 33)
                .offset(y: -3)
                 */
                Toggle("Economy", isOn: $isMetricResult)
                    .toggleStyle(CustomToggle(firstLabel: "L/100Km", secondLabel: "MPG"))
                    .offset(y: -2)
            }
            .foregroundColor(.white)
            .padding(.top, 32)
            
            Button() {
                context.insert(Trip(
                    fuelVolume: isLitres ? fuelVolume : fuelVolume * 3.78541,
                    distance: isKilometers ? distance : distance * 1.60934,
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
            .frame(width: 100, height: 33)
            .padding()
            
            Grid(alignment: .center) {
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
        .background(Color("appColor"))
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
