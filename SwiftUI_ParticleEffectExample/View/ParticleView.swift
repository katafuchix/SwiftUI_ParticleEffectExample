//
//  ParticleView.swift
//  SwiftUI_ParticleEffectExample
//
//  Created by cano on 2025/07/26.
//

import SwiftUI

struct ParticleView: View {
    /// 各ボタンの状態（Like, Star, Share）
    @State private var isLiked: [Bool] = [false, false, false]

    var body: some View {
        VStack {
            // MARK: - ボタン表示エリア（横並び）
            GeometryReader {
                let size = $0.size

                HStack(spacing: 20) {
                    // いいねボタン（ハート）
                    CustomButton(systemImage: "suit.heart.fill", status: isLiked[0], activeTint: .pink, inActiveTint: .gray) {
                        isLiked[0].toggle()
                    }

                    // 星マーク（お気に入り）
                    CustomButton(systemImage: "star.fill", status: isLiked[1], activeTint: .yellow, inActiveTint: .gray) {
                        isLiked[1].toggle()
                    }

                    // 共有ボタン
                    CustomButton(systemImage: "square.and.arrow.up.fill", status: isLiked[2], activeTint: .blue, inActiveTint: .gray) {
                        isLiked[2].toggle()
                    }
                }
                .frame(width: size.width, height: size.height)
            }

            // MARK: - 使用例説明エリア（コードスニペット表示）
            GeometryReader {
                let size = $0.size

                VStack(alignment: .leading, spacing: 20) {
                    Text("Usage")
                        .fontWeight(.semibold)
                        .underline()

                    // particleEffect の使い方例を表示（文字列）
                    Text("""
                    .particleEffect(
                        systemImage: "suit.heart.fill",
                        font: .title2,
                        status: isLiked,
                        inActiveColor: .gray,
                        activeColor: .pink
                    )
                    """)
                    .lineSpacing(5)
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding([.horizontal, .vertical], 15)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color("ButtonColor")) // カスタム色
                }
                .frame(width: size.width, height: size.height)
            }
            .padding(.vertical, 20)
        }
    }

    // MARK: - カスタムボタン定義
    /// アイコン + particleEffect + 背景カプセルつきのカスタムボタン
    @ViewBuilder
    func CustomButton(
        systemImage: String,
        status: Bool,
        activeTint: Color,
        inActiveTint: Color,
        onTap: @escaping () -> ()
    ) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                // パーティクルエフェクトをアイコンに付与
                .particleEffect(
                    systemImage: systemImage,
                    font: .body,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
    }
}
