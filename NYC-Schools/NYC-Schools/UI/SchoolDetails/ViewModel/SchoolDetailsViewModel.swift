//
//  SchoolDetailsViewModel.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import SwiftUI

final class SchoolDetailsViewModel: ObservableObject {
    @Published var state: ViewState<Score> = .notRequested
    let school: School
    var score: Score?
    
    let titleScore = "Score"
    let titleReading = "Reading"
    let titleWriteing = "Writing"
    let titleMath = "Math"
    let titleNumTakers = "Num of sat test takers: "
    let titleOverView = "Overview"
    let scoreNotAvailable = "Score not available"
    
    private let repository: SchoolRepository
    
    init(with repository: SchoolRepository, school: School) {
        self.repository = repository
        self.school = school
    }
    
    func loadScore() {
        repository.fetchScore(for: school.dbn) { [unowned self] result in
            switch result {
            case .success(let score):
                DispatchQueue.main.async {
                    if let sc = score {
                        self.state = .loaded(sc)
                    } else {
                        self.state = .loaded(nil)
                    }
                }
            case .failure(let err):
                self.state = .error(err.description)
            }
        }
    }
}
