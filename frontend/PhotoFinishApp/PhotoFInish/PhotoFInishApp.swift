//
//  PhotoFInishApp.swift
//  PhotoFInish
//
//  Created by Yuchen Zhu on 2/1/24.
//

import SwiftUI
import SwiftData
import AWSCore



@main
struct LoginScreenApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            EmailLogin()
        }
    }
}
