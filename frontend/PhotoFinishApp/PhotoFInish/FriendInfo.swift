import Foundation
import SwiftData

struct FriendInfo: Hashable {
    var username: String
    var totalPoints: String
    
    init(username: String, totalPoints: String) {
        self.username = username
        self.totalPoints = totalPoints
    }
}
