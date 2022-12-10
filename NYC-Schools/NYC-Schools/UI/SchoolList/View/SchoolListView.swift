//
//  SchoolListView.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import SwiftUI

struct SchoolListView: View {
    @ObservedObject var viewModel: SchoolViewModel
    
    var body: some View {
        switch viewModel.state {
        case .notRequested:
            Color.clear.onAppear {
                viewModel.loadSchools(for: true)
            }
        case .loading:
            ProgressView()
        case .loaded(let schools):
            NavigationView {
                if let schools = schools {
                    List(schools) { school in
                        NavigationLink {
                            let schoolDetailsVM = SchoolDetailsViewModel(with: DependencyContainer.shared.schoolRepository, school: school)
                            SchoolDetail(viewModel: schoolDetailsVM)
                        } label: {
                            SchoolRow(school: school)
                                .onAppear {
                                    if schools.last == school {
                                        // scrolling reached the bottom, load next page
                                        viewModel.loadSchools(for: true)
                                    }
                                }
                        }
                    }
                    .navigationTitle(viewModel.title)
                }
            }
        case .error(let err):
            Text(err)
        }
    }
}

struct SchoolListView_Previews: PreviewProvider {
    static var previews: some View {
        let schoolVM = SchoolViewModel(with: DependencyContainer.shared.schoolRepository)
        SchoolListView(viewModel: schoolVM)
    }
}
