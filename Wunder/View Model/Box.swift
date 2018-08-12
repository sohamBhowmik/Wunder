//
//  Box.swift
//  Wunder
//
//  Created by Soham Bhowmik on 09/08/18.
//  Copyright © 2018 soham. All rights reserved.
//

import Foundation

class Box <T> {
    
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?)
    {
        self.listener = listener
        listener?(value)
    }

}
