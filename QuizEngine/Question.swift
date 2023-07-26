public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let type):
            hasher.combine(type)
        case .multipleAnswer(let type):
            hasher.combine(type)
        }
    }
}
