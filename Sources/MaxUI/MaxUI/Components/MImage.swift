import UIKit
import Combine

/// Represents a component for displaying an image
public struct MImage: Componentable {
    public typealias ViewType = MImageView

    /// The image to display in the `MImageView`.
    public var image: ImageSettable? {
        get { _image.value }
        nonmutating set { _image.send(newValue) }
    }

    /// The appearance of the `MImageView`.
    public var appearance: MImageView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }

    fileprivate let _appearance: CurrentValueSubject<MImageView.Appearance, Never>
    fileprivate let _image: CurrentValueSubject<ImageSettable?, Never>

    /// Initializes a new `MImage` component with the specified image.
    ///
    /// - Parameter image: The image to display in the `MImageView`.
    public init(_ image: ImageSettable?) {
        self._image = .init(image)
        self._appearance = .init(MImageView.Appearance())
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
        data._image
            .sink { [weak self] image in
                guard let self else { return }

                image?.setImage(for: self)
            }
            .store(in: &cancellables)

        data._appearance
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
        var layer = SharedAppearance.Layer()
        var common = SharedAppearance.Common().with(\.contentMode, setTo: .scaleAspectFit)
        var isRounded = false
        var tintColor: UIColor?
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
