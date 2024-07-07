//
//  DomainExtensions.swift
//  base_project
//
//  Created by Pranav Singh on 10/12/23.
//

import Foundation
import Combine

//MARK: - Set<AnyCancellable>
typealias AnyCancellablesSet = Set<AnyCancellable>

extension AnyCancellablesSet {
    mutating func cancelAll() {
        forEach { $0.cancel() }
        removeAll()
    }
}
