import Foundation
import Models

/// A struct representing a group of trips.
///
/// `TripGroup` is used to group multiple trips that occur on the same date.
/// It provides properties to access the trips, their total estimated earnings,
/// and the start and end times of the trips in the group.
public struct TripGroup {
  public let dateKey: String
  public let trips: [Trip]
  public let totalEstimatedEarnings: Int
  public let startsAt: Date
  public let endsAt: Date

  /// Returns a formatted string representing the start and end times of the trips in the group.
  public var formattedTime: String {
    let timeFormatter = DateFormatter.sectionTimeFormatter
    return "\(timeFormatter.string(from: startsAt).lowercased()) - \(timeFormatter.string(from: endsAt).lowercased())"
  }

  /// Initializes a new instance of TripGroup.
  ///
  /// - Parameters:
  ///   - dateKey: The key representing the date of the trip group.
  ///   - trips: The list of trips in the group.
  public init(dateKey: String, trips: [Trip]) {
    self.dateKey = dateKey
    self.trips = trips
    totalEstimatedEarnings = trips.reduce(0) { $0 + $1.estimatedEarnings }
    startsAt = trips.first?.plannedRoute.startsAt ?? Date()
    endsAt = trips.last?.plannedRoute.endsAt ?? Date()
  }
}
