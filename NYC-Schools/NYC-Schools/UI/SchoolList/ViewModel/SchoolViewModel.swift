//
//  SchoolViewModel.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation
import SwiftUI


final class SchoolViewModel: ObservableObject {
    @Published var state: ViewState<[School]> = .notRequested
    public let title = "Schools"
    
    private var currPage = -1 //record current page idx
    private var remaining = true //if there is school remaining to download
    
    private let repository: DefaultSchoolRepository
    
    init(with repository: DefaultSchoolRepository) {
        self.repository = repository
    }
    
    public func loadSchools(for nextPage: Bool) {
        guard remaining else { return } //all scholl downloaded
        
        if nextPage {
            currPage += 1
        }
        repository.fetchSchools(page: currPage) { [unowned self] result in
            switch result {
            case .success(let schools):
                if schools.isEmpty {
                    remaining = false // downloaded all items
                } else {
                    DispatchQueue.main.async {
                        if case .loaded(let last) = self.state {
                            self.state = .loaded(schools + (last ?? []))
                        } else {
                            self.state = .loaded(schools)
                        }
                    }
                }
            case .failure(let err):
                if nextPage {
                    self.currPage -= 1
                }
                self.state = .error(err.description)
            }
        }
    }
}
