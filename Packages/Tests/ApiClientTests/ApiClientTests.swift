@testable import ApiClient
import Models
import XCTest

final class ApiClientTests: XCTestCase {
  func testLiveApiClientFetchTrips() async throws {
    // Arrange
    let client = MockApiClient()
    // Act
    do {
      let trips = try await client.fetchTrips()

      // Assert
      XCTAssertFalse(trips.isEmpty, "Trips should not be empty")
      XCTAssertEqual(trips.count, 3, "Trips count should match the expected count")
    } catch {
      XCTFail("Fetching trips failed with error: \(error)")
    }
  }
}
