import SnapKit
import UIKit

class TripSectionHeaderView: UIView {
  let dateLabel = UILabel()
  let timeLabel = UILabel()
  let estimatedLabel = UILabel()
  let estimatedTitleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    layer.masksToBounds = false // Important for shadow
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowRadius = 3

    // Configure labels
    dateLabel.font = UIFont.headerDateFont
    dateLabel.textColor = .darkBlue
    dateLabel.textAlignment = .left

    timeLabel.font = UIFont.headerTimeFont
    timeLabel.textColor = .darkText
    timeLabel.textAlignment = .left

    estimatedTitleLabel.font = UIFont.headerEstimatedTitleFont
    estimatedTitleLabel.textColor = .darkGray
    estimatedTitleLabel.textAlignment = .right
    estimatedTitleLabel.text = "ESTIMATED"

    estimatedLabel.font = UIFont.headerEstimatedFont
    estimatedLabel.textColor = .darkBlue
    estimatedLabel.textAlignment = .right

    // Create stack views
    let hStackView = UIStackView(arrangedSubviews: [dateLabel, timeLabel, UIView(), createVStack()])
    hStackView.axis = .horizontal
    hStackView.distribution = .fill
    hStackView.alignment = .center
    hStackView.spacing = 10

    addSubview(hStackView)
    hStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(10)
    }

    // Add top and bottom borders
    let topBorder = UIView()
    topBorder.backgroundColor = .lightGray
    addSubview(topBorder)
    topBorder.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.left.top.right.equalToSuperview()
    }

    let bottomBorder = UIView()
    bottomBorder.backgroundColor = .lightGray
    addSubview(bottomBorder)
    bottomBorder.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.left.bottom.right.equalToSuperview()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func createVStack() -> UIStackView {
    let vStackView = UIStackView(arrangedSubviews: [estimatedTitleLabel, estimatedLabel])
    vStackView.axis = .vertical
    vStackView.alignment = .trailing
    vStackView.spacing = 2

    return vStackView
  }
}
