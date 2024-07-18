import ApiClient
import ConfirmationAlert
import Models
import SnapKit
import StyleSheet
import UIKit

public class RidesTableViewController: UITableViewController {
  private let viewModel: RidesViewModel
  private let cellIdentifier = "TripTableViewCell"
  private var activityIndicator: UIActivityIndicatorView!
  private var loadTask: Task<Void, Never>? = nil

  /// Initializes a new instance of RidesTableViewController.
  ///
  /// - Parameter viewModel: The view model used to manage ride data.
  public init(viewModel: RidesViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
    setupBindings()
  }

  private func setupBindings() {
    viewModel.onCardTapped = { [weak self] trip in
      self?.presentConfirmationAlert(for: trip)
    }
    viewModel.onError = { [weak self] errorMessage in
      self?.presentErrorAlert(message: errorMessage)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureActivityIndicator()

    // Register the cell class and set table view properties
    tableView.register(TripTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    tableView.separatorStyle = .none

    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }

    // Load the trips and reload the table view
    loadTask = Task { [weak self] in
      if Task.isCancelled {
        return
      }
      await self?.loadData()
    }
  }

  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // Cancel the load task when the view controller is about to disappear
    loadTask?.cancel()
  }

  private func configureNavigationBar() {
    title = "My Rides"

    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .darkBlue
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor.white,
      .font: UIFont.navBarTitleFont,
    ]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
  }

  private func configureActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .darkBlue
    view.addSubview(activityIndicator)

    activityIndicator.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-100)
    }
  }

  /// Loads trip data and updates the table view.
  /// Loads trip data and updates the table view.
  private func loadData() async {
    showLoadingIndicator()
    defer {
      hideLoadingIndicator()
    }

    do {
      await viewModel.loadTrips()
      if Task.isCancelled {
        return
      }
      tableView.reloadData()
    }
  }

  private func showLoadingIndicator() {
    activityIndicator.startAnimating()
    tableView.isUserInteractionEnabled = false
  }

  private func hideLoadingIndicator() {
    activityIndicator.stopAnimating()
    tableView.isUserInteractionEnabled = true
  }

  /// Presents a confirmation alert for the selected trip.
  private func presentConfirmationAlert(for trip: Trip) {
    let alertController = ConfirmationAlertController()
      .setTitle("Are you sure?")
      .setSubtitle("Are you sure you want to cancel this trip? This cannot be undone.")
      .setPrimaryButton(title: "Nevermind", action: {
        print("Primary button tapped")
      })
      .addSecondaryButton(title: "Yes", action: {
        print("Secondary button tapped")
      })

    present(alertController, animated: true, completion: nil)
  }

  /// Presents an error alert with a retry option.
  private func presentErrorAlert(message: String) {
    let alertController = ConfirmationAlertController()
      .setTitle("Error") { label in
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 24)
      }
      .setSubtitle(message)
      .setPrimaryButton(title: "OK") {
        print("OK button tapped")
      }
      .addSecondaryButton(title: "Retry") { [weak self] in
        Task { [weak self] in
          if Task.isCancelled {
            return
          }
          await self?.loadData()
        }
      }

    present(alertController, animated: true, completion: nil)
  }

  override public func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.numberOfSections()
  }

  override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfRows(in: section)
  }

  override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TripTableViewCell else {
      fatalError("Unable to dequeue TripTableViewCell")
    }
    cell.configure(with: viewModel, for: indexPath)
    return cell
  }

  override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = TripSectionHeaderView()
    let tripGroup = viewModel.tripGroup(for: section)

    let dateFormatter = DateFormatter.sectionDayFormatter

    headerView.dateLabel.text = dateFormatter.string(from: tripGroup.startsAt)
    headerView.timeLabel.text = tripGroup.formattedTime
    headerView.estimatedLabel.text = viewModel.totalEstimatedEarnings(for: section)

    return headerView
  }

  override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.cardTapped(at: indexPath)
  }
}

#Preview {
  UINavigationController(rootViewController: RidesTableViewController(viewModel: .init(apiClient: MockApiClient())))
}

#Preview("Activity Indicator") {
  UINavigationController(rootViewController: RidesTableViewController(viewModel: .init(apiClient: MockApiClient(delayInSeconds: 1))))
}
