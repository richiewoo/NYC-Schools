//
//  SchoolDetailsViewModel.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import SwiftUI

final class SchoolDetailsViewModel: ObservableObject {
    @Published var state: ViewState<Score> = .loading
    
    public let school: School
    
    public let titleScore = "Score"
    public let titleReading = "Reading"
    public let titleWriteing = "Writing"
    public let titleMath = "Math"
    public let titleNumTakers = "Num of sat test takers: "
    public let titleOverView = "Overview"
    public let scoreNotAvailable = "Score not available"
    
    private let repository: SchoolRepository
    
    init(with repository: SchoolRepository, school: School) {
        self.repository = repository
        self.school = school
    }
    
    public func loadScore() {
        repository.fetchScore(for: school.dbn) { [unowned self] result in
            switch result {
            case .success(let score):
                DispatchQueue.main.async {
                    self.state = .loaded(score)
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self.state = .error(err.description)
                }
            }
        }
    }
}
