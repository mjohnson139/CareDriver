import Foundation
import Models

/// A protocol defining the requirements for an API client that fetches trips.
public protocol ApiClient: Sendable {
  /// Fetches trips asynchronously.
  /// - Returns: An array of `Trip` objects.
  /// - Throws: An error if the trips cannot be fetched.
  func fetchTrips() async throws -> [Trip]
}

/// A live implementation of the `ApiClient` protocol that fetches trips from a remote server.
public struct LiveApiClient: ApiClient {
  private let urlSession: URLSession
  private let baseURL: URL

  public init(urlSession: URLSession = .shared, baseURL: URL = ApiEndpoints.getTrips) {
    self.urlSession = urlSession
    self.baseURL = baseURL
  }

  public func fetchTrips() async throws -> [Trip] {
    let (data, response) = try await urlSession.data(from: baseURL)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw ApiError.invalidResponse
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601

    do {
      let model = try decoder.decode(Trips.self, from: data)
      return model.trips
    } catch {
      throw ApiError.decodingError
    }
  }
}

/// A mock implementation of the `ApiClient` protocol for testing purposes.
public struct MockApiClient: ApiClient {
  private let delayInSeconds: Int

  /// Initializes a new instance of `MockApiClient`.
  /// - Parameter delayInSeconds: The delay in seconds before returning the mock trips. Defaults to 0 seconds.
  public init(delayInSeconds: Int = 0) {
    self.delayInSeconds = delayInSeconds
  }

  public func fetchTrips() async throws -> [Trip] {
    try await Task.sleep(for: .seconds(delayInSeconds))
    return Trips.mock.trips
  }
}

/// A mock implementation of the `ApiClient` protocol for testing purposes.
public struct MockFailingApiClient: ApiClient {
  private let errorToThrow: ApiError

  /// Initializes a new instance of `MockApiClient`.
  /// - Parameter delayInSeconds: The delay in seconds before returning the mock trips. Defaults to 0 seconds.
  public init(errorToThrow: ApiError) {
    self.errorToThrow = errorToThrow
  }

  public func fetchTrips() async throws -> [Trip] {
    throw errorToThrow
  }
}

/// An enumeration of possible API errors.
public enum ApiError: LocalizedError {
  /// An error indicating a network error occurred.
  case networkError(underlyingError: Error)
  /// An error indicating an invalid response from the server.
  case invalidResponse
  /// An error indicating that decoding the response data failed.
  case decodingError

  /// A localized description of the error.
  public var errorDescription: String? {
    switch self {
    case let .networkError(underlyingError):
      "Network error: \(underlyingError.localizedDescription)"
    case .invalidResponse:
      "Invalid response from the server."
    case .decodingError:
      "Failed to decode the data."
    }
  }
}

/// An enumeration of API endpoints.
public enum ApiEndpoints {
  /// The URL for fetching trips.
  public static let getTrips = URL(string: "https://hopskipdrive-static-files.s3.us-east-2.amazonaws.com/interview-resources/Trip.json")!
}
