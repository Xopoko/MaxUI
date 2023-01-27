import UIKit
import Combine

public struct Image: ComponentViewModelProtocol {
    public typealias ViewType = ImageView
    
    public var image: ImageSettable? {
        get { _image.value }
        nonmutating set { _image.send(newValue) }
    }

    public var appearance: ImageView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
    
    fileprivate let _appearance: CurrentValueSubject<ImageView.Appearance, Never>
    fileprivate let _image: CurrentValueSubject<ImageSettable?, Never>
    
    public init(_ image: ImageSettable?) {
        self._image = .init(image)
        self._appearance = .init(ImageView.Appearance())
    }
}

public final class ImageView: UIImageView {
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

extension ImageView: ReusableView {

    public func configure(with data: Image) {
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
private extension ImageView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        tintColor = appearance.tintColor
        updateCommon(with: appearance.common)
        
        self.appearance = appearance
    }
}

// MARK: - Appearance
extension ImageView {
    public struct Appearance: Equatable, Withable {
        var layer = SharedAppearance.Layer()
        var common = SharedAppearance.Common().with(\.contentMode, setTo: .scaleAspectFit)
        var isRounded = false
        var tintColor: UIColor?
    }
}

extension Image {
    @discardableResult
    public func layer(_ layer: SharedAppearance.Layer) -> Image {
        appearance.layer = layer
        return self
    }
    @discardableResult
    public func common(_ common: SharedAppearance.Common) -> Image {
        appearance.common = common
        return self
    }
    @discardableResult
    public func isRounded(_ isRounded: Bool) -> Image {
        appearance.isRounded = isRounded
        return self
    }
    @discardableResult
    public func tintColor(_ color: UIColor) -> Image {
        appearance.tintColor = color
        return self
    }
}

extension Image: Stylable {
    @discardableResult
    public func style(_ appearance: ImageView.Appearance) -> Self {
        self.appearance = appearance
        return self
    }
}
