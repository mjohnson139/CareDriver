import ApiClient
import SnapKit
import UIKit

class TripTableViewCell: UITableViewCell {
  let timeLabel = UILabel()
  let addressesLabel = UILabel()
  let estimatedEarningsLabel = UILabel()
  let estLabel = UILabel()
  let ridersLabel = UILabel()

  private let containerView = UIView()
  private let mainStackView = UIStackView()
  private let topHStackView = UIStackView()
  private let bottomVStackView = UIStackView()
  private let earningsStackView = UIStackView()
  private let timeAndRidersStackView = UIStackView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    // Configure labels
    timeLabel.numberOfLines = 0
    timeLabel.textAlignment = .left

    addressesLabel.numberOfLines = 0
    addressesLabel.textAlignment = .left
    addressesLabel.font = .cellAddressFont

    estLabel.text = "est."
    estLabel.numberOfLines = 1
    estLabel.textAlignment = .right
    estLabel.textColor = .darkBlue
    estLabel.font = .cellSmallFont

    estimatedEarningsLabel.numberOfLines = 1
    estimatedEarningsLabel.textAlignment = .right
    estimatedEarningsLabel.textColor = .darkBlue

    ridersLabel.numberOfLines = 1
    ridersLabel.textAlignment = .left
    ridersLabel.textColor = .gray
    ridersLabel.font = .cellSmallFont

    // Configure stack views
    mainStackView.axis = .vertical
    mainStackView.alignment = .fill
    mainStackView.distribution = .fill
    mainStackView.spacing = 10
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    mainStackView.backgroundColor = .white
    mainStackView.layer.masksToBounds = false // Important for shadow
    mainStackView.layer.shadowColor = UIColor.black.cgColor
    mainStackView.layer.shadowOpacity = 0.2
    mainStackView.layer.shadowOffset = CGSize(width: 1, height: 1)
    mainStackView.layer.shadowRadius = 5

    topHStackView.axis = .horizontal
    topHStackView.alignment = .center
    topHStackView.distribution = .fill
    topHStackView.spacing = 10

    bottomVStackView.axis = .vertical
    bottomVStackView.alignment = .fill
    bottomVStackView.distribution = .fill
    bottomVStackView.spacing = 10

    earningsStackView.axis = .horizontal
    earningsStackView.alignment = .lastBaseline
    earningsStackView.distribution = .fill
    earningsStackView.spacing = 2

    timeAndRidersStackView.axis = .horizontal
    timeAndRidersStackView.alignment = .lastBaseline
    timeAndRidersStackView.distribution = .fill
    timeAndRidersStackView.spacing = 2

    // Add views to stack views
    timeAndRidersStackView.addArrangedSubview(timeLabel)
    timeAndRidersStackView.addArrangedSubview(ridersLabel)

    topHStackView.addArrangedSubview(timeAndRidersStackView)
    topHStackView.addArrangedSubview(UIView()) // Spacer
    earningsStackView.addArrangedSubview(estLabel)
    earningsStackView.addArrangedSubview(estimatedEarningsLabel)
    topHStackView.addArrangedSubview(earningsStackView)

    bottomVStackView.addArrangedSubview(addressesLabel)

    mainStackView.addArrangedSubview(topHStackView)
    mainStackView.addArrangedSubview(bottomVStackView)

    containerView.addSubview(mainStackView)
    contentView.addSubview(containerView)

    // Add constraints
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }

    mainStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    // Configure card appearance
    containerView.layer.cornerRadius = 4
    containerView.layer.borderWidth = 1
    containerView.layer.borderColor = .lightGray
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with viewModel: RidesViewModel, for indexPath: IndexPath) {
    timeLabel.text = viewModel.tripTime(for: indexPath)
    ridersLabel.text = viewModel.tripRiders(for: indexPath)
    estimatedEarningsLabel.text = viewModel.estimatedEarnings(for: indexPath)
    addressesLabel.text = viewModel.tripAddresses(for: indexPath).joined(separator: "\n")
  }
}
