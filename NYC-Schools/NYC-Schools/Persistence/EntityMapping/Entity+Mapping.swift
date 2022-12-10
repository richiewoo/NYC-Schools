//
//  Entity+Mapping.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import CoreData

// MARK: - Map between application layer data model and Core Data model

extension SchoolMO {
    func toDTO() -> School {
        .init(dbn: dbn!,
              name: name!,
              overview: overview!,
              email: email,
              website: website!,
              address: address!,
              city: city!,
              zip: zip!,
              latitude: latitude,
              longitude: longitude)
    }
}

extension School {
    func toEntity(in context: NSManagedObjectContext) -> SchoolMO {
        let schoolMO = SchoolMO(context: context)
        schoolMO.dbn = dbn
        schoolMO.name = name
        schoolMO.overview = overview
        schoolMO.email = email
        schoolMO.website = website
        schoolMO.address = address
        schoolMO.city = city
        schoolMO.zip = zip
        schoolMO.latitude = latitude
        schoolMO.longitude = latitude
        
        return schoolMO
    }
}
