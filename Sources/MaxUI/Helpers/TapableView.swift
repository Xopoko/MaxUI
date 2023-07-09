import UIKit

// swiftlint:disable:next required_final
open class TapableView: UIControl {

    public enum HighlightBehavior: Equatable {
        public static func == (lhs: HighlightBehavior, rhs: HighlightBehavior) -> Bool {
            switch (lhs, rhs) {
            case (.scale, .scale),
                 (.alpha, .alpha),
                 (.none, .none):
                return true
            case (.custom, .custom):
                return false
            default:
                return false
            }
        }
        
        case scale
        case alpha
        case custom((_ isHighlighted: Bool) -> Void)
        case none
    }

    public var didSelect: (() -> Void)?
    public var highlightBehavior: HighlightBehavior = .alpha
    public var tapAreaInset: UIEdgeInsets { .zero }

    override public var isHighlighted: Bool {
        didSet {
            switch highlightBehavior {
            case .scale:
                Animation.physical.run(.medium) { [weak self] in
                    guard let self = self else { return }
                    self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.95, y: 0.95)
                    : .identity
                }
            case .alpha:
                Animation.default.run(.quick) { [weak self] in
                    guard let self = self else { return }
                    self.alpha = self.isHighlighted ? 0.5 : 1
                }
            case .custom(let animations):
                Animation.default.run(.quick) {
                    animations(self.isHighlighted)
                }
            case .none:
                break
            }
        }
    }

    override public var isEnabled: Bool {
        get { super.isEnabled }
        set { setEnabled(newValue, animated: false) }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds
            .inset(by: tapAreaInset)
            .contains(point)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setEnabled(_ enabled: Bool, animated: Bool) {
        guard isEnabled != enabled else { return }
        super.isEnabled = enabled

        Animation.default.run(.default[animated]) { [weak self] in
            guard let self = self else { return }
            self.alpha = self.isEnabled ? 1 : 0.5
        }
    }

    @objc private func didTap() {
        didSelect?()
    }
}
