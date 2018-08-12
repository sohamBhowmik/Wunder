//
//  WunderTests.swift
//  WunderTests
//
//  Created by Soham Bhowmik on 09/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import XCTest
@testable import Wunder

class WunderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFilterArray(){
        let carViewModel = CarViewModel()
        
        let carA = Car(name: "a123", address: "addA123", engineType: "CE", exterior: "Good", fuel: 21, interior: "good", vin: "abcdefgh", coordinates: [])
        let carB = Car(name: "b123", address: "addB123", engineType: "CE", exterior: "Good", fuel: 21, interior: "good", vin: "abcjasbxdefgh", coordinates: [])
        let carC = Car(name: "cName", address: "testAddress C address", engineType: "CE", exterior: "Good", fuel: 21, interior: "good", vin: "abcxjhqbdefgh", coordinates: [])
        let carD = Car(name: "d123", address: "testaddress D addres", engineType: "CE", exterior: "Good", fuel: 21, interior: "good", vin: "abcdxjhqbefgh", coordinates: [])
        
        let testOutput1 = carViewModel.filterArray(from: [carA, carB, carC, carD], bySearchString: "address")
        let testOutput2 = carViewModel.filterArray(from: [carA, carB, carC, carD], bySearchString: "123")
        
        XCTAssertTrue(testOutput1 == [carC, carD]) //success
        XCTAssertTrue(testOutput1 != [carA, carD]) //success
        
        XCTAssertTrue(testOutput2 == [carA, carB, carD]) //success
        XCTAssertTrue(testOutput2 != [carA, carD]) //success
    }
    
}
