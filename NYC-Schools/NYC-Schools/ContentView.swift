//
//  ContentView.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/8ß/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Create shool list ViewModel and inject dependency
        let schoolVM = SchoolViewModel(with: DependencyContainer.shared.schoolRepository)
        SchoolListView(viewModel: schoolVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
