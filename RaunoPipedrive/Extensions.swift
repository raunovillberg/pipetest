import Foundation

extension Optional where Wrapped == String {
    // Clunky naming.
    // Considered "ifEmptyOrWhitespace(fallbackTo: ), which, uhh, isn't much better.
    func fallbackIfEmptyOrWhitespace(to fallback: String) -> String {
        if let unwrapped = self,
           unwrapped.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            return unwrapped
        }
        return fallback
    }
}

extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isNotEmptyOrWhitespace: Bool {
        isEmptyOrWhitespace == false
    }
}
