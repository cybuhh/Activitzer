import ActivitzerKit
import Foundation

public func getGarminUserConnectionsMock() -> [GarminUserConnection] {
  let usersJson = """
  [{
    "userId": 123456789,
    "displayName": "John Doe",
    "fullName": "John Doe",
    "location": "New York",
    "profileImageUrlLarge": ""https://s3.amazonaws.com/garmin-connect-prod/profile_images/080fc2d2-20a6-43b7-bcb2-76b175aa004a-105107266.png",
    "profileImageUrlMedium": "https://s3.amazonaws.com/garmin-connect-prod/profile_images/a559b532-4183-4da1-b001-62a25122cc9b-105107266.png",
    "profileImageUrlSmall": "https://s3.amazonaws.com/garmin-connect-prod/profile_images/935fde5c-697c-49a2-9f9a-86e01d763271-105107266.png",
    "hasPremiumSocialIcon": false,
    "userLevel": 3,
    "userConnectionStatus": 2,
    "userPro": false,
    "profileVisibility": 3,
    "deviceInvitations": [],
    "nameApproved": true,
    "badgeVisibility": 2
  }]
  """.data(using: .utf8)!

  return try! JSONDecoder().decode(
    [ActivitzerKit.GarminUserConnection].self,
    from: usersJson
  )
}
