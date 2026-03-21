import Foundation

extension Double {
    var cop: String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "$"
        f.currencyCode = "COP"
        f.maximumFractionDigits = 0
        f.locale = Locale(identifier: "es_CO")
        return f.string(from: NSNumber(value: self)) ?? "$0"
    }
}
