import SnapKit
import StyleSheet
import UIKit

public typealias LabelCustomization = (UILabel) -> Void
public typealias ButtonCustomization = (UIButton) -> Void

/// A view controller for displaying a customizable confirmation alert.
///
/// This view controller provides a flexible interface for presenting confirmation alerts
/// with customizable titles, subtitles, primary, and secondary buttons. Each component can
/// be customized using closure-based builder methods.
///
/// Example usage:
/// ```swift
/// let alertController = ConfirmationAlertController()
///     .setTitle("Important Update") { label in
///         label.textColor = .red
///         label.font = UIFont.boldSystemFont(ofSize: 24)
///     }
///     .setSubtitle("This action is irreversible. Are you sure you want to proceed?") { label in
///         label.textColor = .gray
///         label.font = UIFont.systemFont(ofSize: 16)
///     }
///     .setPrimaryButton(title: "Confirm", action: {
///         print("Primary button tapped")
///     }) { button in
///         button.backgroundColor = .green
///         button.setTitleColor(.white, for: .normal)
///     }
///     .addSecondaryButton(title: "Cancel", action: {
///         print("Secondary button tapped")
///     }) { button in
///         button.setTitleColor(.blue, for: .normal)
///     }
///
/// present(alertController, animated: true, completion: nil)
/// ```
public class ConfirmationAlertController: UIViewController {
  private var alertTitle: String?
  private var alertSubtitle: String?
  private var primaryButtonTitle: String?
  private var primaryButtonAction: (() -> Void)?
  private var primaryButtonCustomization: ButtonCustomization?
  private var secondaryButtons: [(title: String, action: () -> Void, customization: ButtonCustomization?)] = []

  // MARK: - UI Elements

  private let containerView = UIView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let buttonStackView = UIStackView()
  private let closeButton = UIButton(type: .system)

  // MARK: - View Lifecycle

  override public func loadView() {
    super.loadView()
    setupView()
    setupConstraints()
  }

  private func setupView() {
    // Configure container view
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 20
    containerView.layer.masksToBounds = false // Important for shadow
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOpacity = 0.2
    containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
    containerView.layer.shadowRadius = 10
    view.addSubview(containerView)

    // Configure close button
    closeButton.setTitle("✕", for: .normal)
    closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    closeButton.tintColor = .black
    closeButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    containerView.addSubview(closeButton)

    // Configure title label
    titleLabel.text = alertTitle
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
    containerView.addSubview(titleLabel)

    // Configure subtitle label
    subtitleLabel.text = alertSubtitle
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0
    subtitleLabel.font = UIFont.systemFont(ofSize: 16)
    containerView.addSubview(subtitleLabel)

    // Configure button stack view
    buttonStackView.axis = .vertical
    buttonStackView.spacing = 10
    buttonStackView.alignment = .fill
    buttonStackView.distribution = .fillEqually
    containerView.addSubview(buttonStackView)

    // Add primary button if exists
    if let primaryTitle = primaryButtonTitle, let primaryAction = primaryButtonAction {
      addButton(title: primaryTitle, action: primaryAction, isPrimary: true, customization: primaryButtonCustomization)
    }

    // Add secondary buttons
    for button in secondaryButtons {
      addButton(title: button.title, action: button.action, isPrimary: false, customization: button.customization)
    }
  }

  private func addButton(title: String, action: @escaping () -> Void, isPrimary: Bool, customization: ButtonCustomization? = nil) {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.backgroundColor = isPrimary ? .darkBlue : .white
    button.setTitleColor(isPrimary ? .white : .darkBlue, for: .normal)
    button.layer.cornerRadius = 5
    button.layer.borderColor = isPrimary ? UIColor.clear.cgColor : UIColor.systemBlue.cgColor
    button.layer.cornerRadius = 20.0

    // Dropshadow
    button.layer.masksToBounds = false // Important for shadow
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOpacity = 0.2
    button.layer.shadowOffset = CGSize(width: 0, height: 0)
    button.layer.shadowRadius = 0.5

    customization?(button)

    button.snp.makeConstraints { make in
      make.height.equalTo(44)
    }
    button.addTarget(self, action: isPrimary ? #selector(primaryButtonTapped) : #selector(secondaryButtonTapped(_:)), for: .touchUpInside)

    if isPrimary {
      buttonStackView.insertArrangedSubview(button, at: 0)
    } else {
      buttonStackView.addArrangedSubview(button)
    }

    button.accessibilityIdentifier = title // Store title to identify button
  }

  private func setupConstraints() {
    containerView.snp.makeConstraints { make in
      make.center.equalTo(view)
      make.leading.equalTo(view).offset(20)
      make.trailing.equalTo(view).offset(-20)
    }

    closeButton.snp.makeConstraints { make in
      make.top.equalTo(containerView).offset(10)
      make.trailing.equalTo(containerView).offset(-10)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(containerView).offset(40)
      make.leading.equalTo(containerView).offset(20)
      make.trailing.equalTo(containerView).offset(-20)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(containerView).offset(20)
      make.trailing.equalTo(containerView).offset(-20)
    }

    buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
      make.leading.equalTo(containerView).offset(20)
      make.trailing.equalTo(containerView).offset(-20)
      make.bottom.equalTo(containerView).offset(-20)
    }
  }

  // Adjust preferredContentSize based on the content size
  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let targetSize = CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height)
    let fittingSize = view.systemLayoutSizeFitting(targetSize)
    preferredContentSize = fittingSize
  }

  // MARK: - Actions

  @objc private func primaryButtonTapped() {
    dismiss(animated: true, completion: primaryButtonAction)
  }

  @objc private func secondaryButtonTapped(_ sender: UIButton) {
    guard let title = sender.accessibilityIdentifier else {
      return
    }
    if let action = secondaryButtons.first(where: { $0.title == title })?.action {
      dismiss(animated: true, completion: action)
    }
  }

  @objc private func dismissAlert() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - Builder Functions

public extension ConfirmationAlertController {
  /// Sets the title for the alert with optional customization.
  /// - Parameters:
  ///   - title: The title text.
  ///   - customization: A closure to customize the title label.
  /// - Returns: The modified `ConfirmationAlertController` instance.
  func setTitle(_ title: String, customization: LabelCustomization? = nil) -> ConfirmationAlertController {
    alertTitle = title
    customization?(titleLabel)
    return self
  }

  /// Sets the subtitle for the alert with optional customization.
  /// - Parameters:
  ///   - subtitle: The subtitle text.
  ///   - customization: A closure to customize the subtitle label.
  /// - Returns: The modified `ConfirmationAlertController` instance.
  func setSubtitle(_ subtitle: String, customization: LabelCustomization? = nil) -> ConfirmationAlertController {
    alertSubtitle = subtitle
    customization?(subtitleLabel)
    return self
  }

  /// Sets the primary button for the alert with optional customization.
  /// - Parameters:
  ///   - title: The button title.
  ///   - action: The action to perform when the button is tapped.
  ///   - customization: A closure to customize the button.
  /// - Returns: The modified `ConfirmationAlertController` instance.
  func setPrimaryButton(title: String, action: @escaping () -> Void, customization: ButtonCustomization? = nil) -> ConfirmationAlertController {
    primaryButtonTitle = title
    primaryButtonAction = action
    primaryButtonCustomization = customization
    return self
  }

  /// Adds a secondary button to the alert with optional customization.
  /// - Parameters:
  ///   - title: The button title.
  ///   - action: The action to perform when the button is tapped.
  ///   - customization: A closure to customize the button.
  /// - Returns: The modified `ConfirmationAlertController` instance.
  func addSecondaryButton(title: String, action: @escaping () -> Void, customization: ButtonCustomization? = nil) -> ConfirmationAlertController {
    secondaryButtons.append((title: title, action: action, customization: customization))
    return self
  }
}

#Preview("Default") {
  ConfirmationAlertController()
    .setTitle("Confirmation Title")
    .setSubtitle("This is the subtitle which is alittle longer and more detail.")
    .setPrimaryButton(title: "Nevermind") {
      print("Primary button tapped")
    }
    .addSecondaryButton(title: "Yes", action: {
      print("Secondary button tapped")
    })
}

#Preview("Bunch of Buttons") {
  ConfirmationAlertController()
    .setTitle("Confirmation Title")
    .setSubtitle("This is the subtitle which is a little longer and more detailed.")
    .setPrimaryButton(title: "Nevermind") {
      print("Primary button tapped")
    }
    .addSecondaryButton(title: "Yes", action: {})
    .addSecondaryButton(title: "No", action: {})
    .addSecondaryButton(title: "Possibly", action: {})
    .addSecondaryButton(title: "Sure", action: {})
    .addSecondaryButton(title: "Thinking about it", action: {})
    .addSecondaryButton(title: "Ask ChatGPT", action: {})
}

#Preview("Customized") {
  ConfirmationAlertController()
    .setTitle("Confirmation Title") { label in
      label.textColor = .systemRed
    }
    .setSubtitle("This is the subtitle which is a little longer and more detailed.") { label in
      label.textColor = .gray
    }
    .setPrimaryButton(title: "Nevermind") {
      print("Primary button tapped")
    } customization: { button in
      button.backgroundColor = .systemCyan
    }
    .addSecondaryButton(title: "Yes", action: {
      print("Secondary button tapped")
    }) { button in
      button.setTitleColor(.blue, for: .normal)
    }
}
