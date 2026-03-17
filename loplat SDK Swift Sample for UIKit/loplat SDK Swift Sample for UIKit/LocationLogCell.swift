//
//  LocationLogCell.swift
//  loplat SDK Swift Sample for UIKit
//

import UIKit
import SnapKit

final class LocationLogCell: UITableViewCell {
    static let reuseIdentifier = "LocationLogCell"

    // MARK: - UI

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let coordinatesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup

    private func setupUI() {
        let topStack = UIStackView(arrangedSubviews: [nameLabel, coordinatesLabel])
        topStack.axis = .horizontal
        topStack.spacing = 8
        topStack.alignment = .center

        let bottomStack = UIStackView(arrangedSubviews: [addressLabel, timestampLabel])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 8
        bottomStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 4

        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }

    // MARK: - Configure

    func configure(with log: LocationLog) {
        nameLabel.text = log.name
        coordinatesLabel.text = String(format: "%.4f, %.4f", log.latitude, log.longitude)
        addressLabel.text = log.address.isEmpty ? "-" : log.address
        timestampLabel.text = log.timestamp
    }
}
