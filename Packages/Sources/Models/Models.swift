import Foundation

/// Models.swift
///
/// This file contains the data models used in the application, which conform to the `Codable`
/// and `Equatable` protocols for easy encoding, decoding, and comparison. These models are designed
/// to be used with JSON data and include initializers for creating instances.
///
/// Example of deserializing a `Passenger` from JSON:
/// ```swift
/// let json = """
/// {
///     "uuid": "8f30452d-b5c2-4047-b8be-4f9e8570c321",
///     "booster_seat": false
/// }
/// """.data(using: .utf8)!
///
/// let decoder = JSONDecoder()
/// decoder.keyDecodingStrategy = .convertFromSnakeCase
/// do {
///     let passenger = try decoder.decode(Passenger.self, from: json)
///     print(passenger)
/// } catch {
///     print("Decoding failed: \(error)")
/// }
/// ```
///
/// Note: The `keyDecodingStrategy` is set to `.convertFromSnakeCase` to automatically convert JSON keys
/// from snake_case to camelCase, which matches the Swift property naming convention.

public struct Trips: Codable, Equatable, Sendable {
  public let trips: [Trip]

  public init(trips: [Trip]) {
    self.trips = trips
  }
}

public struct Trip: Codable, Equatable, Sendable {
  public let estimatedEarnings: Int
  public let slug: String
  public let timeAnchor: String
  public let inSeries: Bool?
  public let passengers: [Passenger]
  public let plannedRoute: PlannedRoute
  public let waypoints: [Waypoint]

  public init(estimatedEarnings: Int, slug: String, timeAnchor: String, inSeries: Bool?, passengers: [Passenger], plannedRoute: PlannedRoute, waypoints: [Waypoint]) {
    self.estimatedEarnings = estimatedEarnings
    self.slug = slug
    self.timeAnchor = timeAnchor
    self.inSeries = inSeries
    self.passengers = passengers
    self.plannedRoute = plannedRoute
    self.waypoints = waypoints
  }
}

public struct Passenger: Codable, Equatable, Sendable {
  public let uuid: String?
  public let boosterSeat: Bool

  public init(uuid: String?, boosterSeat: Bool) {
    self.uuid = uuid
    self.boosterSeat = boosterSeat
  }
}

public struct PlannedRoute: Codable, Equatable, Sendable {
  public let totalTime: Double
  public let totalDistance: Int
  public let startsAt: Date
  public let endsAt: Date
  public let legs: [Leg]

  public init(totalTime: Double, totalDistance: Int, startsAt: Date, endsAt: Date, legs: [Leg]) {
    self.totalTime = totalTime
    self.totalDistance = totalDistance
    self.startsAt = startsAt
    self.endsAt = endsAt
    self.legs = legs
  }
}

public struct Leg: Codable, Equatable, Sendable {
  public let position: Int
  public let startWaypointId: Int
  public let endWaypointId: Int

  public init(position: Int, startWaypointId: Int, endWaypointId: Int) {
    self.position = position
    self.startWaypointId = startWaypointId
    self.endWaypointId = endWaypointId
  }
}

public struct Waypoint: Codable, Equatable, Sendable {
  public let id: Int
  public let location: Location
  public let passengers: [Passenger]

  public init(id: Int, location: Location, passengers: [Passenger]) {
    self.id = id
    self.location = location
    self.passengers = passengers
  }
}

public struct Location: Codable, Equatable, Sendable {
  public let address: String
  public let lat: Double
  public let lng: Double

  public init(address: String, lat: Double, lng: Double) {
    self.address = address
    self.lat = lat
    self.lng = lng
  }
}
