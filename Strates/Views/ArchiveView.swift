import SwiftUI

// MARK: - Vue archive (5 jours précédents)

struct ArchiveView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    private let archiveMots = Calendrier.archiveMots(count: 5)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColors.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // En-tête
                        VStack(spacing: 6) {
                            CharacterView(emotion: .winking, size: 80)
                            Text("Mots précédents")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 8)

                        // Liste des jours
                        ForEach(archiveMots, id: \.mot.id) { item in
                            ArchiveRowView(offset: item.offset, mot: item.mot)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Archive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var backgroundColors: Color {
        colorScheme == .dark
            ? Color(red: 0.08, green: 0.07, blue: 0.14)
            : Color(red: 0.96, green: 0.95, blue: 1.0)
    }
}

struct ArchiveRowView: View {
    let offset: Int
    let mot: MotDuJour
    @State private var expanded = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Header cliquable
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    expanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(labelJour)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        Text(mot.reponse)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(red: 0.45, green: 0.35, blue: 0.90),
                                             Color(red: 0.65, green: 0.45, blue: 1.0)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up.circle.fill" : "chevron.down.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }

            // Strates dépliables
            if expanded {
                VStack(spacing: 0) {
                    Divider().padding(.leading, 16)
                    ForEach(mot.strates) { strate in
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(couleurStrate(strate.id).opacity(0.15))
                                    .frame(width: 26, height: 26)
                                Text("\(strate.id)")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(couleurStrate(strate.id))
                            }
                            VStack(alignment: .leading, spacing: 1) {
                                Text(strate.type)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.tertiary)
                                Text(strate.contenu)
                                    .font(strate.estMono
                                          ? .system(.caption, design: .monospaced).weight(.bold)
                                          : .caption)
                                    .foregroundStyle(strate.estMono ? couleurStrate(strate.id) : .primary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        if strate.id > 1 { Divider().padding(.leading, 50) }
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark
                      ? Color(red: 0.14, green: 0.12, blue: 0.22)
                      : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.purple.opacity(0.15), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var labelJour: String {
        switch offset {
        case -1: return "Hier"
        case -2: return "Il y a 2 jours"
        case -3: return "Il y a 3 jours"
        case -4: return "Il y a 4 jours"
        case -5: return "Il y a 5 jours"
        default: return "Jour \(offset)"
        }
    }

    private func couleurStrate(_ id: Int) -> Color {
        [6: Color(red: 0.55, green: 0.40, blue: 0.95),
         5: Color(red: 0.30, green: 0.60, blue: 1.0),
         4: Color(red: 0.20, green: 0.75, blue: 0.85),
         3: Color(red: 0.25, green: 0.80, blue: 0.55),
         2: Color(red: 0.95, green: 0.65, blue: 0.15),
         1: Color(red: 0.95, green: 0.35, blue: 0.35)][id] ?? .purple
    }
}
