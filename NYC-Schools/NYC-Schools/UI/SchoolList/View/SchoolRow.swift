//
//  SchoolRow.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import SwiftUI

struct SchoolRow: View {
    let school: School
    var body: some View {
        VStack(alignment: .leading) {
            Text(school.name)
            Spacer(minLength: 8)
            HStack {
                Text(school.address)
                
                Spacer()
                
                Text(school.city)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }.padding()
    }
}

struct SchoolListRow_Previews: PreviewProvider {
    static var previews: some View {
        SchoolRow(school: School.default)
            .previewLayout(.fixed(width: 350, height: 50))
    }
}
