//
//  StoredTripsModel.swift
//  FuelCalc
//
//  Created by Nathaniel Bedggood on 25/01/2025.
//

import Foundation
import SwiftData

@Model
class Trip {
    var fuelVolume: Float
    var distance: Float
    var economy: Float
    var date: Date
    
    init(fuelVolume: Float, distance: Float, economy: Float, date: Date) {
        self.fuelVolume = fuelVolume
        self.distance = distance
        self.economy = economy
        self.date = date
    }
    
}
