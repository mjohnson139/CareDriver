import ApiClient
import XCTest

@testable import MyRidesFeature

class RidesViewModelTests: XCTestCase {
  @MainActor
  func testLoadTrips() async throws {
    let viewModel = RidesViewModel(apiClient: MockApiClient())
    await viewModel.loadTrips()
    XCTAssertEqual(viewModel.numberOfSections(), 3)
  }

  @MainActor
  func testLoadTripsFails() async {
    let viewModel = RidesViewModel(apiClient: MockFailingApiClient(errorToThrow: .invalidResponse))
    viewModel.onError = { message in
      XCTAssertEqual("Server error: Received an invalid response.", message)
    }
    await viewModel.loadTrips()
  }

  @MainActor
  func testTripGrouping() async throws {
    let viewModel = RidesViewModel(apiClient: MockApiClient())
    await viewModel.loadTrips()

    XCTAssertEqual(viewModel.tripGroups.count, 3)
    XCTAssertEqual(viewModel.tripGroups[0].dateKey, "2023-11-16")
    XCTAssertEqual(viewModel.tripGroups[1].dateKey, "2023-11-17")
    XCTAssertEqual(viewModel.tripGroups[2].dateKey, "2023-11-18")
  }

  @MainActor
  func testTotalEstimatedEarnings() async throws {
    let viewModel = RidesViewModel(apiClient: MockApiClient())
    await viewModel.loadTrips()

    XCTAssertEqual(viewModel.totalEstimatedEarnings(for: 0), "$20.00")
    XCTAssertEqual(viewModel.totalEstimatedEarnings(for: 1), "$25.00")
    XCTAssertEqual(viewModel.totalEstimatedEarnings(for: 2), "$18.00")
  }

  @MainActor
  func testTripDetails() async throws {
    let viewModel = RidesViewModel(apiClient: MockApiClient())
    await viewModel.loadTrips()

    let indexPath = IndexPath(row: 0, section: 0)
    let trip = viewModel.trip(for: indexPath)

    XCTAssertEqual(trip.slug, "trip1")
    XCTAssertEqual(viewModel.tripTime(for: indexPath), "1:15p - 1:40p")
    XCTAssertEqual(viewModel.tripRiders(for: indexPath), "(3 riders - 1 booster)")
    XCTAssertEqual(viewModel.estimatedEarnings(for: indexPath), "$20.00")
    XCTAssertEqual(viewModel.tripAddresses(for: indexPath), [
      "1. 101 Main St, Huntington Beach 92648",
      "2. 981 CA-1, Seal Beach 90740",
      "3. 6255 2nd St, Long Beach 90803",
      "4. 102 Main St, Huntington Beach 92648",
      "5. 982 CA-1, Seal Beach 90740",
    ])
  }

  @MainActor
  func testNumberOfRowsInSection() async throws {
    let viewModel = RidesViewModel(apiClient: MockApiClient())
    await viewModel.loadTrips()

    XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
    XCTAssertEqual(viewModel.numberOfRows(in: 1), 1)
    XCTAssertEqual(viewModel.numberOfRows(in: 2), 1)
  }
}
