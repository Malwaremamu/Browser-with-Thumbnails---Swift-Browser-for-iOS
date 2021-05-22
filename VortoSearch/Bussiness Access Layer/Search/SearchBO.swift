//
//  SearchBO.swift
//  VortoSearch
//
//  Created by Boyanapalli, Uday (Proagrica) on 5/21/21.
//  Copyright © 2021 Uday Boyanapalli. All rights reserved.
//

import Foundation
struct SearchBO {
    var name:String
    var reviewRating:String
    var address:String
    var distance:String
    var latitude: String
    var longitude: String
    var price:String
    
    init(name:String, reviewRating:String,address:String,distance:String, latitude: String, longitude: String, price: String) {
        self.name = name
        self.reviewRating = reviewRating
        self.address = address
        self.distance = distance
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
    }
}
