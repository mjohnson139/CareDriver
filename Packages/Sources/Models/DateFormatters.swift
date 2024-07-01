import Foundation

/// Some common date formatters used in the project.
public extension DateFormatter {
  /// Used for creating a key from the startsAt data to group trips by date
  static let sectionGroupFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  /// Used for formatting the display of the day in the section headers.
  static let sectionDayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE MM/dd"
    return formatter
  }()

  /// Used for the formatting of the time in the section headers/
  static let sectionTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma"
    formatter.amSymbol = "a"
    formatter.pmSymbol = "p"
    return formatter
  }()
}
