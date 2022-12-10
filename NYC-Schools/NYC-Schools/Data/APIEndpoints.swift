//
//  APIEndpoints.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation

// MARK: - Endpoint builder

struct APIEndpoints {
    /**
     Endpoint to get school:
     https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$limit=5&$offset=0
     **/
    static func getSchools(page: Int, limit: Int = 50) -> Endpoint<[School]> {
        let paramaters = [
            "$limit" : "\(limit)",
            "$offset" : "\(page * limit)"
        ]
        return Endpoint(with: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json", paramaters: paramaters)
    }
    
    /**
     Endpoint to get school score:
     https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn=11X253
     **/
    static func getScore(for school: String) -> Endpoint<[Score]> {
        let paramaters = ["dbn" : "\(school)"]
        return Endpoint(with: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json", paramaters: paramaters)
    }
}
