import ApiClient
import Foundation
import Models

@MainActor
public class RidesViewModel: ObservableObject {
  private var apiClient: ApiClient
  private(set) var tripGroups: [TripGroup] = []

  var onCardTapped: ((Trip) -> Void)?
  var onError: ((String) -> Void)?

  /// Initializes a new instance of RidesViewModel.
  public init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }

  /// Loads trips asynchronously and groups them.
  public func loadTrips() async {
    do {
      let trips = try await apiClient.fetchTrips()
      if Task.isCancelled {
        return
      }
      groupTrips(trips: trips)
    } catch ApiError.networkError(_) {
      if Task.isCancelled {
        return
      }
      onError?("Network error: Please check your internet connection.")
    } catch ApiError.invalidResponse {
      if Task.isCancelled {
        return
      }
      onError?("Server error: Received an invalid response.")
    } catch ApiError.decodingError {
      if Task.isCancelled {
        return
      }
      onError?("Data error: Unable to process the received data.")
    } catch {
      if Task.isCancelled {
        return
      }
      onError?("Unexpected error: Please try again later.")
    }
  }

  /// Groups the trips by their date.
  private func groupTrips(trips: [Trip]) {
    let dateFormatter = DateFormatter.sectionGroupFormatter

    // Group trips by the date key
    let groupedTrips = Dictionary(grouping: trips) { trip in
      dateFormatter.string(from: trip.plannedRoute.startsAt)
    }

    // Create TripGroup objects for each group
    tripGroups = groupedTrips.keys.sorted().map { key in
      TripGroup(dateKey: key, trips: groupedTrips[key]!)
    }
  }

  /// Returns the number of sections.
  public func numberOfSections() -> Int {
    tripGroups.count
  }

  /// Returns the number of rows in a given section.
  public func numberOfRows(in section: Int) -> Int {
    tripGroups[section].trips.count
  }

  /// Returns the trip group for a given section.
  public func tripGroup(for section: Int) -> TripGroup {
    tripGroups[section]
  }

  /// Returns the trip for a given index path.
  public func trip(for indexPath: IndexPath) -> Trip {
    tripGroups[indexPath.section].trips[indexPath.row]
  }

  /// Returns the trip date for a given section.
  public func tripDate(for section: Int) -> String {
    DateFormatter.sectionDayFormatter.string(from: tripGroups[section].startsAt)
  }

  /// Returns the total estimated earnings for a given section.
  public func totalEstimatedEarnings(for section: Int) -> String {
    let total = tripGroups[section].totalEstimatedEarnings
    return "$\(String(format: "%.2f", Double(total) / 100.0))"
  }

  /// Returns the trip time for a given index path.
  public func tripTime(for indexPath: IndexPath) -> String {
    let trip = trip(for: indexPath)
    let dateFormatter = DateFormatter.sectionTimeFormatter
    let start = dateFormatter.string(from: trip.plannedRoute.startsAt).lowercased()
    let end = dateFormatter.string(from: trip.plannedRoute.endsAt).lowercased()
    return "\(start) - \(end)"
  }

  /// Returns the trip riders for a given index path.
  public func tripRiders(for indexPath: IndexPath) -> String {
    let trip = trip(for: indexPath)

    let riders = trip.passengers.count
    let boosters = trip.passengers.filter(\.boosterSeat).count

    let ridersText = riders == 1 ? "1 rider" : "\(riders) riders"
    let boostersText = boosters == 1 ? "1 booster" : "\(boosters) boosters"

    if boosters == 0 {
      return "(" + ridersText + ")"
    } else {
      return "(\(ridersText) - \(boostersText))"
    }
  }

  /// Returns the estimated earnings for a given index path.
  public func estimatedEarnings(for indexPath: IndexPath) -> String {
    let trip = trip(for: indexPath)
    return "$\(String(format: "%.2f", Double(trip.estimatedEarnings) / 100.0))"
  }

  /// Returns the trip addresses for a given index path.
  public func tripAddresses(for indexPath: IndexPath) -> [String] {
    let trip = trip(for: indexPath)
    return trip.waypoints.enumerated().map { index, waypoint in
      var components = waypoint.location.address.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
      if components.count >= 3 {
        let cityZip = components[components.count - 2].split(separator: " ").last ?? ""
        components[components.count - 2] = "\(components[components.count - 3]) \(cityZip)"
        components.removeLast()
        components.remove(at: components.count - 2)
      }
      return "\(index + 1). \(components.joined(separator: ", "))"
    }
  }

  /// Handles the card tap action for a given index path.
  public func cardTapped(at indexPath: IndexPath) {
    let trip = trip(for: indexPath)
    onCardTapped?(trip)
  }
}
