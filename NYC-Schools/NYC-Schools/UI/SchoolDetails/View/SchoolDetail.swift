//
//  SchoolDetail.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import SwiftUI

struct SchoolDetail: View {
    @ObservedObject var viewModel: SchoolDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let locationCoordinate = viewModel.school.locationCoordinate {
                    MapView(coordinate: locationCoordinate)
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 200)
                }
                Text(viewModel.school.name)
                    .font(.title)
                HStack {
                    Text(viewModel.school.address)
                    Spacer()
                    Text(viewModel.school.city)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                switch viewModel.state {
                case .notRequested:
                    Color.clear.onAppear {
                        viewModel.loadScore()
                    }
                case .loading:
                    ProgressView()
                case .loaded(let scr):
                    VStack(alignment: .leading) {
                        Text(viewModel.titleScore)
                            .font(.title2)
                        if let score = scr {
                            Text(viewModel.titleNumTakers + score.numOfTakers)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding([.leading])
                            
                            HStack {
                                Text(viewModel.titleReading)
                                Spacer()
                                Text(score.reading)
                            }
                            .padding([.leading, .trailing])
                            
                            HStack {
                                Text(viewModel.titleWriteing)
                                Spacer()
                                Text(score.writing)
                            }
                            .padding([.leading, .trailing])
                            
                            HStack {
                                Text(viewModel.titleMath)
                                Spacer()
                                Text(score.math)
                            }
                            .padding([.leading, .trailing])
                        } else {
                            HStack {
                                Text(viewModel.scoreNotAvailable)
                            }
                            .padding([.leading, .trailing])
                        }
                    }
                    
                case .error(let err):
                    Text(err)
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text(viewModel.titleOverView)
                        .font(.title2)
                    Text(viewModel.school.overview)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.school.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SchoolDetail_Previews: PreviewProvider {
    static var previews: some View {
        let schoolDetailsVM = SchoolDetailsViewModel(with: DependencyContainer.shared.schoolRepository, school: School.default)
        SchoolDetail(viewModel: schoolDetailsVM)
    }
}
