//
//  School.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation
import CoreLocation

// MARK: - School

struct School {
    let dbn: String
    let name: String
    let overview: String
    let email: String?
    let website: String
    let address: String
    let city: String
    let zip: String
    let latitude: String?
    let longitude: String?
    
    var locationCoordinate: CLLocationCoordinate2D? {
        if let latStr = latitude, let lat = Double(latStr),
            let longStr = longitude, let long = Double(longStr) {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        return nil
    }
}

extension School: Decodable {
    enum CodingKeys: String, CodingKey {
        case dbn = "dbn"
        case name = "school_name"
        case overview = "overview_paragraph"
        case email = "school_email"
        case website = "website"
        case address = "primary_address_line_1"
        case city = "city"
        case zip = "zip"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

extension School: Identifiable {
    var id: String { dbn }
}

extension School: Equatable {
    static func == (lhs: School, rhs: School) -> Bool {
        lhs.id == rhs.id
    }
}

extension School {
    static let `default`: School = {
        School(dbn: "02M260",
               name: "Clinton School Writers & Artists, M.S. 260",
               overview: "",
               email: nil,
               website: "www.theclintonschool.net",
               address: "10 East 15th Street",
               city: "Manhattan",
               zip: "10003",
               latitude: "",
               longitude: "")
    }()
}
