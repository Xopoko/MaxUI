import UIKit
import Combine

// A custom Divider component that can be used to separate UI elements.
public struct MDivider: Componentable {
    public typealias ViewType = MDividerView

    /// The appearance of the Divider.
    public var appearance: MDividerView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }

    fileprivate let _appearance: CurrentValueSubject<MDividerView.Appearance, Never>

    public init(appearance: MDividerView.Appearance = MDividerView.Appearance()) {
        self._appearance = .init(appearance)
    }
}

public final class MDividerView: UIView {
    private let view = UIView()
    private var heightConstraint: NSLayoutConstraint?

    public init() {
        super.init(frame: .zero)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MDividerView: ReusableView {
    public func configure(with data: MDivider) {
        updateAppearance(appearance: data.appearance)
    }
}

// MARK: - Private methods
extension MDividerView {
    private func setupLayout() {
        view.fill(in: self)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: .zero)
        heightConstraint?.isActive = true
    }

    private func updateAppearance(appearance: Appearance) {
        view.layer.cornerRadius = appearance.cornerRadius
        view.backgroundColor = appearance.color
        heightConstraint?.constant = appearance.height
    }
}

extension MDividerView {
    public struct Appearance: Equatable {
        public var cornerRadius: CGFloat
        public var color: UIColor
        public var height: CGFloat

        public init(
            cornerRadius: CGFloat = .zero,
            color: UIColor = .lightGray,
            height: CGFloat = 1 / UIScreen.main.scale
        ) {
            self.cornerRadius = cornerRadius
            self.color = color
            self.height = height
        }
    }
}

extension MDivider {
    /// Sets the cornerRadius for the `Divider` appearance.
    ///
    /// - Parameter cornerRadius: The cornerRadius to set.
    /// - Returns: The updated `Divider` instance.
    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        appearance.cornerRadius = cornerRadius
        return self
    }

    /// Sets the color for the `Divider` appearance.
    ///
    /// - Parameter color: A color to set.
    /// - Returns: The updated `Divider` instance.
    @discardableResult
    public func color(_ color: UIColor) -> Self {
        appearance.color = color
        return self
    }

    /// Sets the height for the `Divider` appearance.
    ///
    /// - Parameter height: A height to set.
    /// - Returns: The updated `Divider` instance.
    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        appearance.height = height
        return self
    }
}

extension MDivider: Stylable {
    @discardableResult
    public func style(_ appearance: MDividerView.Appearance) -> MDivider {
        self.appearance = appearance
        return self
    }
}

#if DEBUG
import SwiftUI
struct Divider_Previews: PreviewProvider {
    static var previews: some View {
        ComponentPreview(distribution: .center) {
            MDivider()
        }
    }
}
#endif
