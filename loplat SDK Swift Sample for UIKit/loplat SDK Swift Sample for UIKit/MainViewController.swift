//
//  MainViewController.swift
//  loplat SDK Swift Sample for UIKit
//

import UIKit
import SnapKit
import Combine

final class MainViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    private var onboardingVC: OnboardingViewController?

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(PermissionCell.self, forCellReuseIdentifier: PermissionCell.reuseIdentifier)
        tv.register(SDKStatusCell.self, forCellReuseIdentifier: SDKStatusCell.reuseIdentifier)
        tv.register(LocationLogCell.self, forCellReuseIdentifier: LocationLogCell.reuseIdentifier)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    // MARK: - Init

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refreshStatus()
        showOnboardingIfNeeded()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "로플랫 SDK Sample"
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        [
            viewModel.$locationLogs.map { _ in }.eraseToAnyPublisher(),
            viewModel.$sdkStarted.map { _ in }.eraseToAnyPublisher(),
            viewModel.$currentLocationPermission.map { _ in }.eraseToAnyPublisher(),
            viewModel.$currentATTPermission.map { _ in }.eraseToAnyPublisher(),
            viewModel.$currentNotificationPermission.map { _ in }.eraseToAnyPublisher()
        ].forEach { publisher in
            publisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in self?.tableView.reloadData() }
                .store(in: &cancellables)
        }
    }

    // MARK: - Onboarding

    private func showOnboardingIfNeeded() {
        guard viewModel.needShowOnboarding, onboardingVC == nil else { return }

        let vc = OnboardingViewController()
        vc.onConfirm = { [weak self] in
            self?.viewModel.confirmOnboarding()
            self?.onboardingVC?.dismiss(animated: true)
            self?.onboardingVC = nil
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
        onboardingVC = vc
    }

    // MARK: - Navigation

    private func openGoogleMaps(latitude: Double, longitude: Double) {
        let urlString = "https://www.google.com/maps/place/\(latitude),\(longitude)"
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3                                           // 위치, ATT, 알림
        case 1: return 1                                           // SDK start/stop
        case 2: return min(viewModel.locationLogs.count, 3) + 1   // 최대 3개 + 더보기
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PermissionCell.reuseIdentifier, for: indexPath) as! PermissionCell
            switch indexPath.row {
            case 0:
                cell.configure(title: "위치", statusText: viewModel.currentLocationString, canRequest: viewModel.canRequestLocation)
                cell.onButtonTap = { [weak self] in self?.viewModel.requestLocationPermission() }
            case 1:
                cell.configure(title: "ATT", statusText: viewModel.currentATTString, canRequest: viewModel.canRequestATT)
                cell.onButtonTap = { [weak self] in self?.viewModel.requestATTPermission() }
            case 2:
                cell.configure(title: "알림", statusText: viewModel.currentNotificationString, canRequest: viewModel.canRequestNotification)
                cell.onButtonTap = { [weak self] in self?.viewModel.requestNotificationPermission() }
            default: break
            }
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SDKStatusCell.reuseIdentifier, for: indexPath) as! SDKStatusCell
            cell.configure(started: viewModel.sdkStarted)
            cell.onStartTap = { [weak self] in self?.viewModel.startSDK() }
            cell.onStopTap = { [weak self] in self?.viewModel.stopSDK() }
            return cell

        case 2:
            let logCount = min(viewModel.locationLogs.count, 3)
            if indexPath.row < logCount {
                let cell = tableView.dequeueReusableCell(withIdentifier: LocationLogCell.reuseIdentifier, for: indexPath) as! LocationLogCell
                cell.configure(with: viewModel.locationLogs[indexPath.row])
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "위치 로그 더 보기"
                cell.textLabel?.textColor = .systemBlue
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.font = .systemFont(ofSize: 15)
                cell.accessoryType = .disclosureIndicator
                return cell
            }

        default:
            return UITableViewCell()
        }
    }

    // MARK: Headers & Footers

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "권한"
        case 2: return "위치 로그"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }

        // SDK 섹션 헤더: 좌측에 "SDK", 우측에 버전 표시
        let headerView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = "SDK"
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel

        let versionLabel = UILabel()
        versionLabel.text = viewModel.sdkVersion
        versionLabel.font = .systemFont(ofSize: 12)
        versionLabel.textColor = .secondaryLabel

        headerView.addSubview(titleLabel)
        headerView.addSubview(versionLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(6)
        }
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(6)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 36 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 2 else { return nil }
        return "최초 설치의 경우, SDK가 시작되고 약 2분 안에 첫 이벤트를 받습니다."
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 2 else { return }

        let logCount = min(viewModel.locationLogs.count, 3)
        if indexPath.row < logCount {
            let log = viewModel.locationLogs[indexPath.row]
            openGoogleMaps(latitude: log.latitude, longitude: log.longitude)
        } else {
            let logVC = LogViewController(locationLogs: viewModel.locationLogs)
            navigationController?.pushViewController(logVC, animated: true)
        }
    }
}
