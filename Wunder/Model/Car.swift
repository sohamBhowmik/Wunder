//
//  Car.swift
//  Wunder
//
//  Created by Soham Bhowmik on 09/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import Foundation

struct Placemark: Decodable
{
    let placemarks: [Car]
}

struct Car: Decodable {
    let address: String?
    let engineType: String?
    let exterior: String?
    let fuel: Float?
    let interior: String?
    let name: String?
    let vin: String?
    let coordinates: [Double]
    
    init(name: String?, address: String?, engineType: String?, exterior: String?, fuel: Float?, interior: String?, vin: String?, coordinates:[Double]?)
    {
        self.address = address
        self.engineType = engineType
        self.exterior = exterior
        self.fuel = fuel
        self.interior = interior
        self.name = name
        self.vin = vin
        self.coordinates = coordinates ?? []
    }
}

extension Car: Equatable{}
    
    func ==(lhs: Car, rhs: Car) -> Bool {
    let areEqual = lhs.vin == rhs.vin    
    return areEqual
    }

