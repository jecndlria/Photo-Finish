//
//  UsernameManager.swift
//  PhotoFInish
//
//  Created by yuchen zhu on 3/11/24.
//

import Foundation
import SwiftUI

class UsernameManager: ObservableObject {
    @Published var username = ""
    @Published var wrongUsername = false

    // Singleton pattern
    static let shared = UsernameManager()

    private init() {}
}
