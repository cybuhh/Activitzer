import ActivitzerKit
import Foundation

func handleError(_ error: Error) {
  switch error {
  case RequestError.tooManyRequests:
    print("Too many requests")

  case GarminConnectTokenManager.GetValidTokenError.login:
    print("Can't login and generate new token")

  case GarminConnectTokenManager.GetValidTokenError.noValidAccessToken:
    print("No valid access token found")

  default:
    print("Error:", error)
  }
}
