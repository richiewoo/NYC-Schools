//
//  ViewState.swift
//  NYC-Schools
//
//  Created by Xinbo Wu on 12/9/22.
//

import Foundation

enum ViewState<T> {
    case loading
    case loaded(T?)
    case error(String)
}
