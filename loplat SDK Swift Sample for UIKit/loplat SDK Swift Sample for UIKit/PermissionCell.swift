//
//  PermissionCell.swift
//  loplat SDK Swift Sample for UIKit
//

import UIKit
import SnapKit

final class PermissionCell: UITableViewCell {
    static let reuseIdentifier = "PermissionCell"

    var onButtonTap: (() -> Void)?

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private let statusButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
        let button = UIButton(configuration: config)
        button.isHidden = true
        return button
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemBlue
        label.textAlignment = .right
        label.isHidden = true
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
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(statusButton)
        contentView.addSubview(statusLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        statusButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        }

        statusLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        statusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        onButtonTap?()
    }

    // MARK: - Configure

    func configure(title: String, statusText: String, canRequest: Bool) {
        titleLabel.text = title

        if canRequest {
            statusButton.isHidden = false
            statusLabel.isHidden = true
            var config = statusButton.configuration
            config?.title = statusText
            statusButton.configuration = config
        } else {
            statusButton.isHidden = true
            statusLabel.isHidden = false
            statusLabel.text = statusText
        }
    }
}
