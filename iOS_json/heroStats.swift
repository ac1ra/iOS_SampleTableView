//
//  heroStats.swift
//  iOS_json
//
//  Created by ac1ra on 10.08.2021.
//

import Foundation
struct heroStats:Decodable {
    var id:Int
    var localized_name:String
    var primary_attr:String
    var attack_type:String
    var img:String
}
