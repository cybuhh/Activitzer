struct GarminActivity: Codable, Identifiable {
  let id: Int
  let activityName: String
  let startTimeLocal: String
  let startTimeGMT: String
  let createDate: String
    
  let activityType: GarminActivityType
  let eventType: GarminEventType
  let privacy: GarminPrivacy
    
  let distance: Double
  let duration: Double
  let elapsedDuration: Double
    
  let elevationGain: Double?
  let elevationLoss: Double?
    
  let averageSpeed: Double?
  let maxSpeed: Double?
    
  let startLatitude: Double?
  let startLongitude: Double?
  let endLatitude: Double?
  let endLongitude: Double?
    
  let ownerId: Int
  let ownerDisplayName: String
  let ownerFullName: String
    
  let ownerProfileImageUrlSmall: String?
  let ownerProfileImageUrlMedium: String?
  let ownerProfileImageUrlLarge: String?
    
  let calories: Double?
  let averageHR: Int?
  let maxHR: Int?
    
  let steps: Int?
    
  let lapCount: Int?
    
  let hasPolyline: Bool?
  let hasSplits: Bool?
  let hasHeatMap: Bool?
    
  let favorite: Bool?
  let pr: Bool?
    
  let activityImages: [GarminActivityImage]
    
  enum CodingKeys: String, CodingKey {
    case id = "activityId"
    case activityName
    case startTimeLocal
    case startTimeGMT
    case createDate
    case activityType
    case eventType
    case privacy
    case distance
    case duration
    case elapsedDuration
    case elevationGain
    case elevationLoss
    case averageSpeed
    case maxSpeed
    case startLatitude
    case startLongitude
    case endLatitude
    case endLongitude
    case ownerId
    case ownerDisplayName
    case ownerFullName
    case ownerProfileImageUrlSmall
    case ownerProfileImageUrlMedium
    case ownerProfileImageUrlLarge
    case calories
    case averageHR
    case maxHR
    case steps
    case lapCount
    case hasPolyline
    case hasSplits
    case hasHeatMap
    case favorite
    case pr
    case activityImages
  }
}
