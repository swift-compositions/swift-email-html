public import Email_Standard
import HTML

extension Email.VStack {

    public enum Alignment: Sendable, Hashable, CaseIterable {
        case start
        case center
        case end

        public var textAlign: String {
            switch self {
            case .start: "start"
            case .center: "center"
            case .end: "end"
            }
        }
    }
}
