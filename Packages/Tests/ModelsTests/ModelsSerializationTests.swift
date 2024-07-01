@testable import Models
import XCTest

final class ModelsSerializationTests: XCTestCase {
  func testPassengerSerialization() {
    let json = """
    {
        "uuid": "8f30452d-b5c2-4047-b8be-4f9e8570c321",
        "booster_seat": false
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    do {
      let passenger = try decoder.decode(Passenger.self, from: json)
      XCTAssertEqual(passenger.uuid, "8f30452d-b5c2-4047-b8be-4f9e8570c321")
      XCTAssertEqual(passenger.boosterSeat, false)
    } catch {
      XCTFail("Decoding failed: \(error)")
    }
  }

  func testLocationSerialization() {
    let json = """
    {
        "address": "101 Main St, Huntington Beach, CA 92648, USA",
        "lat": 33.6577394,
        "lng": -118.0018199
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()

    do {
      let location = try decoder.decode(Location.self, from: json)
      XCTAssertEqual(location.address, "101 Main St, Huntington Beach, CA 92648, USA")
      XCTAssertEqual(location.lat, 33.6577394)
      XCTAssertEqual(location.lng, -118.0018199)
    } catch {
      XCTFail("Decoding failed: \(error)")
    }
  }

  func testWaypointSerialization() {
    let json = """
    {
        "id": 1252826,
        "location": {
            "address": "101 Main St, Huntington Beach, CA 92648, USA",
            "lat": 33.6577394,
            "lng": -118.0018199
        },
        "passengers": []
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()

    do {
      let waypoint = try decoder.decode(Waypoint.self, from: json)
      XCTAssertEqual(waypoint.id, 1_252_826)
      XCTAssertEqual(waypoint.location.address, "101 Main St, Huntington Beach, CA 92648, USA")
      XCTAssertEqual(waypoint.location.lat, 33.6577394)
      XCTAssertEqual(waypoint.location.lng, -118.0018199)
      XCTAssertEqual(waypoint.passengers.count, 0)
    } catch {
      XCTFail("Decoding failed: \(error)")
    }
  }

  func testLegSerialization() {
    let json = """
    {
        "position": 1,
        "start_waypoint_id": 1252826,
        "end_waypoint_id": 1252827
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    do {
      let leg = try decoder.decode(Leg.self, from: json)
      XCTAssertEqual(leg.position, 1)
      XCTAssertEqual(leg.startWaypointId, 1_252_826)
      XCTAssertEqual(leg.endWaypointId, 1_252_827)
    } catch {
      XCTFail("Decoding failed: \(error)")
    }
  }

  func testPlannedRouteSerialization() {
    let json = """
    {
        "total_time": 25.9,
        "total_distance": 15781,
        "starts_at": "2023-11-16T18:15:00Z",
        "ends_at": "2023-11-16T18:40:55Z",
        "legs": [
            {
                "position": 1,
                "start_waypoint_id": 1252826,
                "end_waypoint_id": 1252827
            },
            {
                "position": 2,
                "start_waypoint_id": 1252827,
                "end_waypoint_id": 1252828
            }
        ]
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601

    do {
      let plannedRoute = try decoder.decode(PlannedRoute.self, from: json)
      XCTAssertEqual(plannedRoute.totalTime, 25.9)
      XCTAssertEqual(plannedRoute.totalDistance, 15781)
      XCTAssertEqual(plannedRoute.startsAt, ISO8601DateFormatter().date(from: "2023-11-16T18:15:00Z"))
      XCTAssertEqual(plannedRoute.endsAt, ISO8601DateFormatter().date(from: "2023-11-16T18:40:55Z"))
      XCTAssertEqual(plannedRoute.legs.count, 2)
      XCTAssertEqual(plannedRoute.legs[0].position, 1)
      XCTAssertEqual(plannedRoute.legs[0].startWaypointId, 1_252_826)
      XCTAssertEqual(plannedRoute.legs[0].endWaypointId, 1_252_827)
    } catch {
      XCTFail("Decoding failed: \(error)")
    }
  }

  func testWithMissingPassengerUUIDAndInSeriesFields() {
    let json = """
    {
      "trips": [
        {
          "estimated_earnings": 2914,
          "slug": "af05ab6c6d0964",
          "time_anchor": "pick_up",
          "passengers": [
            {
              "booster_seat": false
            }
          ],
          "planned_route": {
            "total_time": 63.5,
            "total_distance": 46924,
            "starts_at": "2023-11-17T17:00:00Z",
            "ends_at": "2023-11-17T18:03:30Z",
            "legs": [
              {
                "position": 1,
                "start_waypoint_id": 1239662,
                "end_waypoint_id": 1239663
              }
            ]
          },
          "waypoints": [
            {
              "id": 1239662,
              "location": {
                "address": "7 Pepper Tree Ln, Rolling Hills Estates, CA 90274, USA",
                "lat": 33.7611392,
                "lng": -118.3921106
              },
              "passengers": []
            },
            {
              "id": 1239663,
              "location": {
                "address": "1321 Cortez St, Los Angeles, CA 90026, USA",
                "lat": 34.066333,
                "lng": -118.2559734
              },
              "passengers": [
                {
                  "uuid": "ee7d9d26-1441-41a3-b392-162a6977bad5",
                  "booster_seat": false
                }
              ]
            }
          ]
        }
      ]
    }
    """.data(using: .utf8)!

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601

    do {
      let trips = try decoder.decode(Trips.self, from: json).trips
      XCTAssertEqual(trips.count, 1)

      // Validate the trip
      let trip = trips[0]
      XCTAssertEqual(trip.estimatedEarnings, 2914)
      XCTAssertEqual(trip.slug, "af05ab6c6d0964")
      XCTAssertEqual(trip.timeAnchor, "pick_up")
      XCTAssertNil(trip.inSeries, "inSeries")

      XCTAssertEqual(trip.passengers.count, 1)
      XCTAssertNil(trip.passengers[0].uuid)
      XCTAssertEqual(trip.passengers[0].boosterSeat, false)

    } catch {
      XCTFail("Decoding failed: \(error)")
    }
  }
}
