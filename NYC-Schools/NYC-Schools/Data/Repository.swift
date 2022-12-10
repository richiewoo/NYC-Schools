//
//  Repository.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import CoreData

enum DataRepositoryError: Error {
    case networkError(String)
    case databaseError(String)
}

extension DataRepositoryError: CustomStringConvertible {
    var description: String {
        switch self {
        case .networkError(let string):
            return string
        case .databaseError(let string):
            return string
        }
    }
}

protocol SchoolRepository {
    func fetchSchools(page: Int, limit: Int, completion: @escaping (Result<[School], DataRepositoryError>) -> Void)
    
    func fetchScore(for school: String, completion: @escaping (Result<Score?, DataRepositoryError>) -> Void)
}

class DefaultSchoolRepository: SchoolRepository {
    let networService: NetworkService
    let dbRepository: PersistentStore
    let cancelBag = CancelBag()
    
    init(with networService: NetworkService, dbRepository: PersistentStore) {
        self.networService = networService
        self.dbRepository = dbRepository
    }
    
    func fetchSchools(page: Int, limit: Int = 50, completion: @escaping (Result<[School], DataRepositoryError>) -> Void) {
        
        let request = SchoolMO.schoolListRequest(page, limit: limit)
        dbRepository.fetchSchools(request)
            .receive(on: RunLoop.main)
            .sink { [unowned self] done in
                self.cancelBag.cancel()
                
                switch done {
                case let .failure(error):
                    completion(.failure(.databaseError(error.localizedDescription)))
                default: break
                }
            } receiveValue: { [unowned self] schools in
                self.cancelBag.cancel()
                if schools.isEmpty {
                    let endpoint = APIEndpoints.getSchools(page: page, limit: limit)
                    self.networService.request(with: endpoint) { result in
                        switch result {
                        case .success(let schools):
                            self.dbRepository.update { context in
                                schools.forEach { $0.toEntity(in: context) }
                            }
                            completion(.success(schools))
                        case .failure(let error):
                            completion(.failure(.networkError(error.description)))
                        }
                    }
                } else {
                    completion(.success(schools))
                }
            }
            .store(in: cancelBag)
    }
    
    func fetchScore(for school: String, completion: @escaping (Result<Score?, DataRepositoryError>) -> Void) {
        let endpoint = APIEndpoints.getScore(for: school)
        networService.request(with: endpoint) { result in
            switch result {
            case .success(let score):
                completion(.success(score.first))
            case .failure(let error):
                completion(.failure(.networkError(error.description)))
            }
        }
    }
}
