#if DEBUG
  import Foundation

  ///
  /// This file contains mock data extensions for model objects, designed to be used
  /// only in debug mode. These extensions provide static properties with sample data
  /// to facilitate testing and development without relying on real data.
  ///
  /// Usage:
  /// - Access the mock data through the static properties defined in each model's extension.
  /// - This file will only be included in the build when the DEBUG flag is set, ensuring
  ///   that the mock data is not included in production builds.

  public extension Passenger {
    static let mockPassengers1: [Passenger] = [
      Passenger(uuid: "passenger1-1", boosterSeat: false),
      Passenger(uuid: "passenger1-2", boosterSeat: true),
      Passenger(uuid: "passenger1-3", boosterSeat: false),
    ]

    static let mockPassengers2: [Passenger] = [
      Passenger(uuid: "passenger2-1", boosterSeat: false),
      Passenger(uuid: "passenger2-2", boosterSeat: true),
      Passenger(uuid: "passenger2-3", boosterSeat: false),
    ]

    static let mockPassengers3: [Passenger] = [
      Passenger(uuid: "passenger3-1", boosterSeat: false),
      Passenger(uuid: "passenger3-2", boosterSeat: true),
      Passenger(uuid: "passenger3-3", boosterSeat: false),
    ]
  }

  public extension Location {
    static let mockLocation1 = Location(address: "101 Main St, Huntington Beach, CA 92648, USA", lat: 33.6577394, lng: -118.0018199)
    static let mockLocation2 = Location(address: "981 CA-1, Seal Beach, CA 90740, USA", lat: 33.744308, lng: -118.101178)
    static let mockLocation3 = Location(address: "6255 2nd St, Long Beach, CA 90803, USA", lat: 33.7585003, lng: -118.1128225)
    static let mockLocation4 = Location(address: "102 Main St, Huntington Beach, CA 92648, USA", lat: 33.6577395, lng: -118.0018200)
    static let mockLocation5 = Location(address: "982 CA-1, Seal Beach, CA 90740, USA", lat: 33.744309, lng: -118.101179)
  }

  public extension Waypoint {
    static let mockWaypoint1 = Waypoint(id: 1_252_826, location: Location.mockLocation1, passengers: Passenger.mockPassengers1)
    static let mockWaypoint2 = Waypoint(id: 1_252_827, location: Location.mockLocation2, passengers: Passenger.mockPassengers1)
    static let mockWaypoint3 = Waypoint(id: 1_252_828, location: Location.mockLocation3, passengers: Passenger.mockPassengers1)
    static let mockWaypoint4 = Waypoint(id: 1_252_829, location: Location.mockLocation4, passengers: Passenger.mockPassengers2)
    static let mockWaypoint5 = Waypoint(id: 1_252_830, location: Location.mockLocation5, passengers: Passenger.mockPassengers3)
  }

  public extension PlannedRoute {
    static let mockPlannedRoute1 = PlannedRoute(
      totalTime: 25.9,
      totalDistance: 15781,
      startsAt: ISO8601DateFormatter().date(from: "2023-11-16T18:15:00Z")!,
      endsAt: ISO8601DateFormatter().date(from: "2023-11-16T18:40:55Z")!,
      legs: [
        Leg(position: 1, startWaypointId: 1_252_826, endWaypointId: 1_252_827),
        Leg(position: 2, startWaypointId: 1_252_827, endWaypointId: 1_252_828),
        Leg(position: 3, startWaypointId: 1_252_828, endWaypointId: 1_252_829),
        Leg(position: 4, startWaypointId: 1_252_829, endWaypointId: 1_252_830),
      ]
    )

    static let mockPlannedRoute2 = PlannedRoute(
      totalTime: 30.0,
      totalDistance: 20000,
      startsAt: ISO8601DateFormatter().date(from: "2023-11-17T08:00:00Z")!,
      endsAt: ISO8601DateFormatter().date(from: "2023-11-17T08:30:00Z")!,
      legs: [
        Leg(position: 1, startWaypointId: 1_252_829, endWaypointId: 1_252_830),
        Leg(position: 2, startWaypointId: 1_252_830, endWaypointId: 1_252_828),
        Leg(position: 3, startWaypointId: 1_252_828, endWaypointId: 1_252_827),
      ]
    )

    static let mockPlannedRoute3 = PlannedRoute(
      totalTime: 15.5,
      totalDistance: 12000,
      startsAt: ISO8601DateFormatter().date(from: "2023-11-18T14:00:00Z")!,
      endsAt: ISO8601DateFormatter().date(from: "2023-11-18T14:15:30Z")!,
      legs: [
        Leg(position: 1, startWaypointId: 1_252_830, endWaypointId: 1_252_829),
        Leg(position: 2, startWaypointId: 1_252_829, endWaypointId: 1_252_827),
        Leg(position: 3, startWaypointId: 1_252_827, endWaypointId: 1_252_826),
      ]
    )
  }

  public extension Trips {
    static let mock: Trips = .init(trips: [
      Trip(
        estimatedEarnings: 2000,
        slug: "trip1",
        timeAnchor: "2023-11-16T18:15:00Z",
        inSeries: true,
        passengers: Passenger.mockPassengers1,
        plannedRoute: PlannedRoute.mockPlannedRoute1,
        waypoints: [Waypoint.mockWaypoint1, Waypoint.mockWaypoint2, Waypoint.mockWaypoint3, Waypoint.mockWaypoint4, Waypoint.mockWaypoint5]
      ),
      Trip(
        estimatedEarnings: 2500,
        slug: "trip2",
        timeAnchor: "2023-11-17T08:00:00Z",
        inSeries: true,
        passengers: Passenger.mockPassengers2,
        plannedRoute: PlannedRoute.mockPlannedRoute2,
        waypoints: [Waypoint.mockWaypoint4, Waypoint.mockWaypoint5, Waypoint.mockWaypoint3]
      ),
      Trip(
        estimatedEarnings: 1800,
        slug: "trip3",
        timeAnchor: "2023-11-18T14:00:00Z",
        inSeries: true,
        passengers: Passenger.mockPassengers3,
        plannedRoute: PlannedRoute.mockPlannedRoute3,
        waypoints: [Waypoint.mockWaypoint5, Waypoint.mockWaypoint4, Waypoint.mockWaypoint2, Waypoint.mockWaypoint1]
      ),
    ])
  }
#endif
