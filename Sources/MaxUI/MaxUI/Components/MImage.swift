import UIKit
import Combine

/// Represents a component for displaying an image
public struct MImage: Componentable {
    public typealias ViewType = MImageView
    
    /// The image to display in the `MImageView`.
    @MBinding
    public var image: ImageSettable?

    /// The appearance of the `MImageView`.
    @MBinding
    public var appearance: MImageView.Appearance

    /// Initializes a new `MImage` component with the specified image.
    ///
    /// - Parameter image: The image to display in the `MImageView`.
    public init(_ image: ImageSettable?) {
        self.init(.dynamic(image))
    }
    
    public init(_ image: MBinding<ImageSettable?>) {
        self._image = image
        self._appearance = .dynamic(MImageView.Appearance())
    }
}

public final class MImageView: UIImageView {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()

    override public func layoutSubviews() {
        super.layoutSubviews()

        if let appearance = appearance {
            updateLayer(with: appearance.layer)
            if appearance.isRounded == true {
                layer.masksToBounds = true
                layer.cornerRadius = max(bounds.width, bounds.height) / 2
            }
        }
    }
}

extension MImageView: ReusableView {
    public func configure(with data: MImage) {
        data.$image.publisher
            .sink { [weak self] image in
                guard let self else { return }

                image?.setImage(for: self)
            }
            .store(in: &cancellables)

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
extension MImageView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        tintColor = appearance.tintColor
        
        updateCommon(with: appearance.common)

        self.appearance = appearance
    }
}

// MARK: - Appearance
extension MImageView {
    public struct Appearance: Equatable, Withable {
        public var layer: SharedAppearance.Layer
        public var common: SharedAppearance.Common
        public var isRounded: Bool
        public var tintColor: UIColor?
        
        public init(
            layer: SharedAppearance.Layer = SharedAppearance.Layer(),
            common: SharedAppearance.Common = SharedAppearance.Common(contentMode: .scaleAspectFit),
            isRounded: Bool = false,
            tintColor: UIColor? = nil
        ) {
            self.layer = layer
            self.common = common
            self.isRounded = isRounded
            self.tintColor = tintColor
        }
    }
}

extension MImage {
    /// Sets the layer properties of the `MImage`.
    ///
    /// - Parameter layer: The new layer properties to set.
    /// - Returns: The updated `MImage` instance.
    @discardableResult
    public func layer(_ layer: SharedAppearance.Layer) -> MImage {
        appearance.layer = layer
        return self
    }

    /// Sets the common properties of the `MImage`.
    ///
    /// - Parameter common: The new common properties to set.
    /// - Returns: The updated `MImage` instance.
    @discardableResult
    public func common(_ common: SharedAppearance.Common) -> MImage {
        appearance.common = common
        return self
    }

    /// Sets the rounded corner properties of the `MImage`.
    ///
    /// - Parameter isRounded: The new rounded corner property to set.
    /// - Returns: The updated `MImage` instance.
    @discardableResult
    public func isRounded(_ isRounded: Bool) -> MImage {
        appearance.isRounded = isRounded
        return self
    }

    /// Sets the tint color property of the `MImage`.
    ///
    /// - Parameter color: The new tint color to set.
    /// - Returns: The updated `MImage` instance.
    @discardableResult
    public func tintColor(_ color: UIColor) -> MImage {
        appearance.tintColor = color
        return self
    }

}

extension MImage: Stylable {
    @discardableResult
    public func style(_ appearance: MImageView.Appearance) -> Self {
        self.appearance = appearance
        return self
    }
}
