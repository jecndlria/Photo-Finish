//
//  PhotoFInishApp.swift
//  PhotoFInish
//
//  Created by Yuchen Zhu on 2/1/24.
//

import SwiftUI
import SwiftData
import AWSCore

var user = "joshtet"

@main
struct LoginScreenApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            LoginPage2()
        }
    }
}
