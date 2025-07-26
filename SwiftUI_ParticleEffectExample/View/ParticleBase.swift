//
//  ParticleView.swift
//  SwiftUI_ParticleEffectExample
//
//  Created by cano on 2025/07/26.
//

import SwiftUI

// MARK: - View 拡張：パーティクルエフェクトのカスタムModifierを適用
extension View {
    /// 指定した SF Symbol を使ってパーティクルエフェクトを表示するModifier
    @ViewBuilder
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color) -> some View {
        self
            .modifier(
                ParticleModifier(
                    systemImage: systemImage,
                    font: font,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
            )
    }
}

// MARK: - パーティクル表示を制御するViewModifier
fileprivate struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color

    // パーティクルの配列
    @State private var particles: [Particle] = []

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(particles) { particle in
                        Image(systemName: systemImage)
                            .font(font)
                            .foregroundColor(status ? activeTint : inActiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            // アクティブなときのみ表示
                            .opacity(status ? 1 : 0)
                            // アニメーション無効化（状態が切り替わった瞬間に反映）
                            .animation(.none, value: status)
                    }
                }
                .onAppear {
                    // 初回のみパーティクルを初期化（個数は任意で変更可）
                    if particles.isEmpty {
                        for _ in 1...15 {
                            particles.append(Particle())
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        // 非アクティブ時はすべてのパーティクルを初期化（リセット）
                        for index in particles.indices {
                            particles[index].reset()
                        }
                    } else {
                        // アクティブ時：各パーティクルに個別の動きとスケールを設定
                        for index in particles.indices {
                            let total = CGFloat(particles.count)
                            let progress = CGFloat(index) / total

                            let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY: CGFloat = 60

                            let baseX = (progress > 0.5 ? progress - 0.5 : progress) * maxX
                            let baseY = (progress > 0.5 ? progress - 0.5 : progress) * maxY + 35

                            let randomScale: CGFloat = .random(in: 0.35...1)

                            // スプリングで位置アニメーション（飛び散るような動き）
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                let extraRandomX: CGFloat = progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0)
                                let extraRandomY: CGFloat = .random(in: 0...30)

                                particles[index].randomX = baseX + extraRandomX
                                particles[index].randomY = -baseY - extraRandomY
                            }

                            // 拡大アニメーション（ふわっと表示）
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[index].scale = randomScale
                            }

                            // 一定時間後に徐々に縮小（消えるようなアニメーション）
                            withAnimation(
                                .interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)
                                    .delay(0.25 + Double(index) * 0.005)
                            ) {
                                particles[index].scale = 0.001
                            }
                        }
                    }
                }
            }
    }
}
