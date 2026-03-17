//
//  SDKStatusCell.swift
//  loplat SDK Swift Sample for UIKit
//

import UIKit
import SnapKit

final class SDKStatusCell: UITableViewCell {
    static let reuseIdentifier = "SDKStatusCell"

    var onStartTap: (() -> Void)?
    var onStopTap: (() -> Void)?

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "상태"
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        return label
    }()

    private let actionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
        return UIButton(configuration: config)
    }()

    private var isStarted: Bool = false

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
        contentView.addSubview(statusLabel)
        contentView.addSubview(actionButton)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        }

        statusLabel.snp.makeConstraints {
            $0.trailing.equalTo(actionButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }

        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        isStarted ? onStopTap?() : onStartTap?()
    }

    // MARK: - Configure

    func configure(started: Bool) {
        isStarted = started
        statusLabel.text = started ? "started" : "stopped"
        var config = actionButton.configuration
        config?.title = started ? "stop" : "start"
        actionButton.configuration = config
    }
}
