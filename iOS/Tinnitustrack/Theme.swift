import SwiftUI

/// Bespoke palette + type for Tinnitustrack - Ringing Ear Log.
enum Theme {
    static let background = Color(hex: "#180B0F")
    static let primary = Color(hex: "#5B2333")
    static let secondary = Color(hex: "#9A5A6A")
    static let accent = Color(hex: "#F26D5B")
    static let cardBackground = Color(hex: "#180B0F").opacity(0.6)

    static let titleFont = Font.custom("American Typewriter", size: 28).weight(.bold)
    static let headlineFont = Font.custom("American Typewriter", size: 18).weight(.semibold)
    static let bodyFont = Font.custom("American Typewriter", size: 16)
    static let captionFont = Font.custom("American Typewriter", size: 13)
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
