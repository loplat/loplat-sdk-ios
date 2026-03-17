//
//  LogViewController.swift
//  loplat SDK Swift Sample for UIKit
//

import UIKit
import SnapKit

final class LogViewController: UIViewController {

    // MARK: - Properties

    private let locationLogs: [LocationLog]

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.register(LocationLogCell.self, forCellReuseIdentifier: LocationLogCell.reuseIdentifier)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    // MARK: - Init

    init(locationLogs: [LocationLog]) {
        self.locationLogs = locationLogs
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "위치 로그"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Navigation

    private func openGoogleMaps(latitude: Double, longitude: Double) {
        let urlString = "https://www.google.com/maps/place/\(latitude),\(longitude)"
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - UITableViewDataSource

extension LogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationLogs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationLogCell.reuseIdentifier, for: indexPath) as! LocationLogCell
        cell.configure(with: locationLogs[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let log = locationLogs[indexPath.row]
        openGoogleMaps(latitude: log.latitude, longitude: log.longitude)
    }
}
