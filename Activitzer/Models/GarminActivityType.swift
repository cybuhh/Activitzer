struct GarminActivityType: Codable {
  let typeId: Int
  let typeKey: String
  let parentTypeId: Int
  let isHidden: Bool
  let restricted: Bool
  let trimmable: Bool
}
