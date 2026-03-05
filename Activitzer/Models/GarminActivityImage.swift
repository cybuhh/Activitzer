import Foundation

struct GarminActivityImage: Codable, Identifiable {
  let id: String
  let url: URL
  let smallUrl: URL?
  let mediumUrl: URL?
  let feedUrl: URL?
  
  let expirationTimestamp: Int64?
  
  let latitude: Double?
  let longitude: Double?
  
  let photoDate: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "imageId"
    case url
    case smallUrl
    case mediumUrl
    case feedUrl
    case expirationTimestamp
    case latitude
    case longitude
    case photoDate
  }
}
