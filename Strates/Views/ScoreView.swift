import SwiftUI

// MARK: - Score mot courant + session cumulatif

struct ScoreView: View {
    @ObservedObject var vm: GameViewModel
    @State private var animatedScore: Int = 1000
    @State private var animatedSession: Int = 0

    var body: some View {
        VStack(spacing: 10) {

            // ── Ligne principale : score mot + delta ──
            HStack(alignment: .firstTextBaseline, spacing: 6) {

                VStack(alignment: .leading, spacing: 0) {
                    Text("Ce mot")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .tracking(0.5)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(animatedScore)")
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundStyle(scoreColor)
                            .contentTransition(.numericText(countsDown: vm.scoreDelta < 0))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: animatedScore)
                        Text("pts")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }

                // Delta flottant
                if vm.showDelta {
                    Text(vm.scoreDelta >= 0 ? "+\(vm.scoreDelta)" : "\(vm.scoreDelta)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(vm.scoreDelta >= 0 ? Color.green : Color.red)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background((vm.scoreDelta >= 0 ? Color.green : Color.red).opacity(0.12))
                        .clipShape(Capsule())
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal:   .move(edge: .top).combined(with: .opacity)
                        ))
                }

                Spacer()

                // ── Score session cumulatif ──
                if vm.scoreSession > 0 || vm.motsJoues.count > 0 {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("Session")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.tertiary)
                            .tracking(0.5)
                        HStack(alignment: .firstTextBaseline, spacing: 3) {
                            Text("\(animatedSession)")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundStyle(LinearGradient(
                                    colors: [Color(red:0.45,green:0.35,blue:0.90),
                                             Color(red:0.65,green:0.45,blue:1.0)],
                                    startPoint: .leading, endPoint: .trailing))
                                .contentTransition(.numericText())
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: animatedSession)
                            Text("pts")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            // ── Barre de progression du mot courant ──
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(progressGradient)
                        .frame(width: geo.size.width * vm.scoreProgression, height: 10)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: vm.scoreProgression)

                    // Reflet
                    RoundedRectangle(cornerRadius: 6)
                        .fill(LinearGradient(
                            colors: [Color.white.opacity(0.4), Color.clear],
                            startPoint: .top, endPoint: .bottom))
                        .frame(width: geo.size.width * vm.scoreProgression, height: 5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: vm.scoreProgression)
                }
            }
            .frame(height: 10)

            // ── Labels ──
            HStack {
                Text("Strate 6")
                    .font(.caption2).foregroundStyle(.tertiary)
                Spacer()
                // Combo badge si actif
                if vm.comboActuel > 1 {
                    HStack(spacing: 3) {
                        Image(systemName: "bolt.fill").font(.system(size: 9, weight: .bold))
                        Text("x\(vm.comboActuel) COMBO").font(.system(size: 10, weight: .bold))
                    }
                    .foregroundStyle(.orange)
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())
                }
                Spacer()
                Text("Strate 1")
                    .font(.caption2).foregroundStyle(.tertiary)
            }
        }
        .onChange(of: vm.scoreActuel) { _, v in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { animatedScore = v }
        }
        .onChange(of: vm.scoreSession) { _, v in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) { animatedSession = v }
        }
        .onAppear {
            animatedScore   = vm.scoreActuel
            animatedSession = vm.scoreSession
        }
    }

    private var scoreColor: Color {
        let r = vm.scoreProgression
        if r > 0.65 { return Color(red: 0.25, green: 0.78, blue: 0.42) }
        if r > 0.35 { return Color(red: 0.95, green: 0.65, blue: 0.15) }
        return Color(red: 0.90, green: 0.30, blue: 0.25)
    }

    private var progressGradient: LinearGradient {
        let r = vm.scoreProgression
        let colors: [Color]
        if r > 0.65 { colors = [Color(red:0.25,green:0.85,blue:0.50), Color(red:0.15,green:0.70,blue:0.38)] }
        else if r > 0.35 { colors = [Color(red:1.0,green:0.78,blue:0.20), Color(red:0.95,green:0.55,blue:0.10)] }
        else { colors = [Color(red:1.0,green:0.45,blue:0.35), Color(red:0.85,green:0.20,blue:0.15)] }
        return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
    }
}
