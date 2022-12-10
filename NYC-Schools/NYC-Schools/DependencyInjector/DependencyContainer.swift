//
//  DependencyContainer.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation

// MARK: - Dependency injector

struct DependencyContainer {
    public static let shared = DependencyContainer()
    
    var schoolRepository: DefaultSchoolRepository = {
        DefaultSchoolRepository(with: NetworkService(), dbRepository: SchoolCoreDataDB())
    }()
}

