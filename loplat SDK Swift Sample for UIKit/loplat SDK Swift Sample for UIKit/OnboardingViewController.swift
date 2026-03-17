//
//  OnboardingViewController.swift
//  loplat SDK Swift Sample for UIKit
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    var onConfirm: (() -> Void)?

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로플랫"
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()

    private let mapIllustrationView = MapIllustrationView()

    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private let bodyLabel1: UILabel = {
        let label = UILabel()
        label.text = "로플랫 SDK(MiniPlengi)를 테스트할 수 있는 샘플앱이며, UIKit을 기반으로 작성되었습니다."
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    private let bodyLabel2: UILabel = {
        let label = UILabel()
        label.text = "프로덕션 적용을 위해서는 로플랫에서 발급받은 클라이언트 아이디와 비밀번호가 필요합니다."
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    private let bodyLabel3: UILabel = {
        let label = UILabel()
        label.text = "자세한 내용은 아래의 링크를 참조해주세요."
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()

    private let linkButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "developers.loplat.com/docs/ios/"
        config.image = UIImage(systemName: "link")
        config.imagePadding = 4
        config.baseForegroundColor = .systemBlue
        config.contentInsets = .zero
        return UIButton(configuration: config)
    }()

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.text = "내용을 확인하신 후 아래 버튼을 눌러주세요"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "확인하였습니다"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var updated = attrs
            updated.font = UIFont.boldSystemFont(ofSize: 17)
            return updated
        }
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .fixed
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // ScrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(140) // 버튼 영역 확보
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }

        // Title
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).inset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        // Map Illustration
        contentView.addSubview(mapIllustrationView)
        mapIllustrationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }

        // Info Container
        contentView.addSubview(infoContainerView)
        infoContainerView.snp.makeConstraints {
            $0.top.equalTo(mapIllustrationView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }

        // Info Container contents
        let bodyStack = UIStackView(arrangedSubviews: [bodyLabel1, bodyLabel2, bodyLabel3])
        bodyStack.axis = .vertical
        bodyStack.spacing = 12

        infoContainerView.addSubview(bodyStack)
        infoContainerView.addSubview(divider)
        infoContainerView.addSubview(linkButton)

        bodyStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }

        divider.snp.makeConstraints {
            $0.top.equalTo(bodyStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(0.5)
        }

        linkButton.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }

        // Bottom area (fixed)
        view.addSubview(hintLabel)
        view.addSubview(confirmButton)

        hintLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(confirmButton.snp.top).offset(-12)
        }

        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(56)
        }

        linkButton.addTarget(self, action: #selector(linkTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func linkTapped() {
        guard let url = URL(string: "https://developers.loplat.com/docs/ios/"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    @objc private func confirmTapped() {
        onConfirm?()
    }
}

// MARK: - MapIllustrationView

private final class MapIllustrationView: UIView {

    private let gradientLayer = CAGradientLayer()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "map")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        layer.cornerRadius = 16
        clipsToBounds = true

        gradientLayer.colors = [
            UIColor(red: 0.82, green: 0.88, blue: 0.97, alpha: 1).cgColor,
            UIColor(red: 0.93, green: 0.96, blue: 1.0, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(64)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
