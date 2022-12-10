//
//  Score.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation

// MARK: - Score

struct Score {
    let dbn: String
    let name: String
    let numOfTakers: String
    let reading: String
    let math: String
    let writing: String
}

extension Score: Decodable {
    enum CodingKeys: String, CodingKey {
        case dbn = "dbn"
        case name = "school_name"
        case numOfTakers = "num_of_sat_test_takers"
        case reading = "sat_critical_reading_avg_score"
        case math = "sat_math_avg_score"
        case writing = "sat_writing_avg_score"
    }
}
