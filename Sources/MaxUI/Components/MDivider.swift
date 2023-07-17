import UIKit
import Combine

// A custom Divider component that can be used to separate UI elements.
public struct MDivider: Componentable, Withable {
    public typealias ViewType = MDividerView

    @MBinding
    public var appearance: MDividerView.Appearance

    public init(appearance: MDividerView.Appearance) {
        self._appearance = .dynamic(appearance)
    }
    
    public init(
        color: UIColor = .systemGray,
        thickness: CGFloat = 1 / UIScreen.main.scale
    ) {
        self._appearance = .dynamic(
            .init(
                color: color,
                thickness: thickness
            )
        )
    }
}

public final class MDividerView: UIView {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()

    public override var intrinsicContentSize: CGSize {
        let thickness = appearance?.thickness ?? 1 / UIScreen.main.scale
        return CGSize(width: UIView.noIntrinsicMetric, height: thickness)
    }
}

extension MDividerView: ReusableView {
    public func configure(with data: MDivider) {
        data.$appearance.publisher
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)
    }
    
    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension MDividerView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        backgroundColor = appearance.color

        self.appearance = appearance
    }
}

extension MDividerView {
    public struct Appearance: Equatable {
        public var color: UIColor
        public var thickness: CGFloat
        
        public init(
            color: UIColor = .systemGray,
            thickness: CGFloat = 1 / UIScreen.main.scale
        ) {
            self.color = color
            self.thickness = thickness
        }
    }
}

extension MDivider {
    /// Sets the color for the `Divider` appearance.
    ///
    /// - Parameter color: A color to set.
    /// - Returns: The updated `Divider` instance.
    @discardableResult
    public func color(_ color: UIColor) -> Self {
        with(\.appearance.color, setTo: color)
    }

    /// Sets the height for the `Divider` appearance.
    ///
    /// - Parameter thickness: A thickness to set.
    /// - Returns: The updated `Divider` instance.
    @discardableResult
    public func thickness(_ thickness: CGFloat) -> Self {
        with(\.appearance.thickness, setTo: thickness)
    }
}

extension MDivider: Stylable {
    @discardableResult
    public func style(_ appearance: MDividerView.Appearance) -> MDivider {
        with(\.appearance, setTo: appearance)
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
