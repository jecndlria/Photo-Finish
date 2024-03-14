//
//  FriendInfoManager.swift
//  PhotoFInish
//
//  Created by yuchen zhu on 3/13/24.
//

import Foundation


class FriendInfoManager: ObservableObject {
    @Published var entries: [FriendInfo] = []
    
    static let shared = FriendInfoManager()

    private init() {}
}
