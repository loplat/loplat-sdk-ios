//
//  MainView.swift
//  loplat SDK Swift Sample for SwiftUI
//

import SwiftUI

// MARK: - Main View

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    permissionSection
                    sdkStatusSection
                    locationLogsSection
                }
                .listStyle(.insetGrouped)
                .navigationTitle("로플랫 SDK Sample")
            }
            .navigationViewStyle(.stack)

            OnboardingView {
                withAnimation {
                    viewModel.confirmOnboarding()
                }
            }
            .opacity(viewModel.needShowOnboarding ? 1 : 0)
        }
        .onAppear {
            viewModel.refreshStatus()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.refreshStatus()
            }
        }
    }

    // MARK: 권한

    private var permissionSection: some View {
        Section("권한") {
            HStack {
                Text("위치")
                Spacer()
                if viewModel.canRequestLocation {
                    Button(viewModel.currentLocationString) {
                        viewModel.requestLocationPermission()
                    }
                    .foregroundStyle(Color.blue)
                    .buttonStyle(.bordered)
                    .frame(width: 60)
                } else {
                    Text(viewModel.currentLocationString)
                        .foregroundStyle(Color.blue)
                }
            }

            HStack {
                Text("ATT")
                Spacer()
                if viewModel.canRequestATT {
                    Button(viewModel.currentATTString) {
                        viewModel.requestATTPermission()
                    }
                    .foregroundStyle(Color.blue)
                    .buttonStyle(.bordered)
                    .frame(width: 60)
                } else {
                    Text(viewModel.currentATTString)
                        .foregroundStyle(Color.blue)
                        .frame(width: 60)
                }
            }

            HStack {
                Text("알림")
                Spacer()
                if viewModel.canRequestNotification {
                    Button(viewModel.currentNotificationString) {
                        viewModel.requestNotificationPermission()
                    }
                    .foregroundStyle(Color.blue)
                    .buttonStyle(.bordered)
                    .frame(width: 60)
                } else {
                    Text(viewModel.currentNotificationString)
                        .foregroundStyle(Color.blue)
                        .frame(width: 60)
                }
            }
        }
    }

    // MARK: SDK

    private var sdkStatusSection: some View {
        Section {
            VStack(spacing: 24) {
                HStack {
                    Text("상태")
                    Spacer()
                    HStack(spacing: 16) {
                        Text(viewModel.sdkStarted ? "started" : "stopped")

                        if viewModel.sdkStarted {
                            Button("stop") {
                                viewModel.stopSDK()
                            }
                            .foregroundStyle(Color.blue)
                            .buttonStyle(.bordered)
                        } else {
                            Button("start") {
                                viewModel.startSDK()
                            }
                            .foregroundStyle(Color.blue)
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        } header: {
            HStack {
                Text("SDK")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                Spacer()
                Text(viewModel.sdkVersion)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
        }
    }

    // MARK: 위치 로그

    private var locationLogsSection: some View {
        Section {
            ForEach(viewModel.locationLogs.prefix(3)) { log in
                LocationLogRow(log: log)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let urlString = "https://www.google.com/maps/place/"+"\(log.latitude),\(log.longitude)"
                        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
                        UIApplication.shared.open(url)
                    }
            }

            NavigationLink(destination: LogView(locationLogs: viewModel.locationLogs)) {
                Text("위치 로그 더 보기")
                    .font(.subheadline)
                    .foregroundStyle(Color.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        } header: {
            HStack {
                Text("위치 로그")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                Spacer()
            }
        } footer: {
            Text("최초 설치의 경우, SDK가 시작되고 약 2분 안에 첫 이벤트를 받습니다.")
                .font(.caption2)
        }
    }
}
