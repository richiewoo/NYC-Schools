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
                //Basic info views
                Text(viewModel.school.name)
                    .font(.title)
                HStack {
                    Text(viewModel.school.address)
                    Spacer()
                    Text(viewModel.school.city)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                // Map view
                if let locationCoordinate = viewModel.school.locationCoordinate {
                    MapView(coordinate: locationCoordinate)
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 200)
                }
                
                Divider()
                
                // Score views
                Text(viewModel.titleScore)
                        .font(.title2)
                
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .task {
                            viewModel.loadScore()
                        }
                case .loaded(let scr):
                    VStack(alignment: .leading) {
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
                
                // Overview
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
