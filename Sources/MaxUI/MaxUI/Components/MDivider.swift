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
    private let path = UIBezierPath()
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
    
    public override var intrinsicContentSize: CGSize {
        let thickness = appearance?.thickness ?? 1 / UIScreen.main.scale
        return CGSize(width: UIView.noIntrinsicMetric, height: thickness)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        let thickness = appearance?.thickness ?? 1 / UIScreen.main.scale
        let leadingInset = appearance?.leadingInset ?? 0
        let trailingInset = appearance?.trailingInset ?? 0
        let yPosition = (rect.height / 2) - (thickness / 2)
        
        appearance?.color.setStroke()
        
        path.lineWidth = thickness
        path.move(to: CGPoint(x: leadingInset, y: yPosition))
        path.addLine(to: CGPoint(x: rect.width - trailingInset, y: yPosition))
        path.stroke()
    }
       
}

extension MDividerView: ReusableView {
    public func configure(with data: MDivider) {
        data._appearance
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)
        
        updateAppearance(appearance: data.appearance)
    }
}

// MARK: - Private methods
extension MDividerView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        setNeedsDisplay()
        backgroundColor = .clear
        
        self.appearance = appearance
    }
}

extension MDividerView {
    public struct Appearance: Equatable {
        public var color: UIColor
        public var thickness: CGFloat
        public var leadingInset: CGFloat
        public var trailingInset: CGFloat

        public init(
            color: UIColor = .systemGray,
            thickness: CGFloat = 1 / UIScreen.main.scale,
            leadingInset: CGFloat = 0,
            trailingInset: CGFloat = 0
        ) {
            self.color = color
            self.thickness = thickness
            self.leadingInset = leadingInset
            self.trailingInset = trailingInset
        }
    }
}

extension MDividerView: Spaceable {
    var isReadyToBeSpaceable: Bool { true }
}

extension MDivider {
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
    /// - Parameter thickness: A thickness to set.
    /// - Returns: The updated `Divider` instance.
    @discardableResult
    public func thickness(_ thickness: CGFloat) -> Self {
        appearance.thickness = thickness
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
