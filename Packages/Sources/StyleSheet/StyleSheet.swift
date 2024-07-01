import UIKit

public extension UIColor {
  static let darkBlue = UIColor(red: 0, green: 0.34, blue: 0.54, alpha: 1.0)
}

public extension CGColor {
  static let lightGray = UIColor.lightGray.cgColor
}

public extension UIFont {
  static let navBarTitleFont = UIFont.boldSystemFont(ofSize: 24)
  static let headerDateFont = UIFont.boldSystemFont(ofSize: 16)
  static let headerTimeFont = UIFont.systemFont(ofSize: 14)
  static let headerEstimatedTitleFont = UIFont.systemFont(ofSize: 12)
  static let headerEstimatedFont = UIFont.systemFont(ofSize: 14)
  static let cellAddressFont = UIFont.systemFont(ofSize: 14)
  static let cellSmallFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
}
