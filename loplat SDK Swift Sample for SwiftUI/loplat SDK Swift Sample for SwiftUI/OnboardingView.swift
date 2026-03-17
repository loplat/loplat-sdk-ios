//
//  OnboardingView.swift
//  loplat SDK Swift Sample for SwiftUI
//

import SwiftUI

struct OnboardingView: View {
    var onConfirm: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 24) {
            Text("로플랫")
                .font(.system(size: 40, weight: .bold))
                .padding(.top, 32)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
        
            mapIllustration
                .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("로플랫 SDK(MiniPlengi)를 테스트할 수 있는 샘플앱이며, SwiftUI를 기반으로 작성되었습니다.")
                        .font(.callout)
                    
                    Text("프로덕션 적용을 위해서는 로플랫에서 발급받은 클라이언트 아이디와 비밀번호가 필요합니다.")
                        .font(.callout)
                    
                    Text("자세한 내용은 아래의 링크를 참조해주세요.")
                        .font(.callout)
                }
                
                Divider()
                
                Link(destination: URL(string: "https://developers.loplat.com/docs/ios/")!) {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                        Text("developers.loplat.com/docs/ios/")
                    }
                    .font(.body)
                    .foregroundStyle(Color.blue)
                }
            }
            .padding()
            .background(Color.init(red: 248.0/255.0, green: 250.0/255.0, blue: 252.0/255.0))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("내용을 확인하신 후 아래 버튼을 눌러주세요")
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                
                Button(action: onConfirm) {
                    Text("확인하였습니다")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .padding(.top, 12)
        }
        .background(Color(.systemBackground))
    }
    
    private var mapIllustration: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.82, green: 0.88, blue: 0.97),
                            Color(red: 0.93, green: 0.96, blue: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            
            Image(systemName: "map")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundStyle(Color.blue)
        }
    }
}
