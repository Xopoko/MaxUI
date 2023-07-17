import UIKit
import Combine

/// A component view model struct that represents a text component and conforms to the
/// Componentable and Textable protocols.
public struct MText: Componentable, Textable, DeclarativeCommon {
    /// The type of the view that represents the component view model.
    public typealias ViewType = MTextView

    /// A binding that holds the text value.
    @MBinding public var text: String?
    /// A binding that holds the text appearance value.
    @MBinding public var textAppearance = MTextView.Appearance()
    /// A binding that holds the attributed text value.
    @MBinding public var attributedText: NSAttributedString?
    
    var isHidden: MBinding<Bool>?
    var isUserInteractionEnabled: MBinding<Bool>?
    var alpha: MBinding<CGFloat>?
    var contentMode: MBinding<UIView.ContentMode>?
    var backgroundColor: MBinding<UIColor?>?
    var clipsToBounds: MBinding<Bool>?
    var priority: MBinding<SharedAppearance.Priority>?
    var cornerRadius: MBinding<CGFloat>?
    var cornersToRound: MBinding<[UIRectCorner]>?
    var borderWidth: MBinding<CGFloat>?
    var borderColor: MBinding<UIColor>?
    var shadow: MBinding<SharedAppearance.Layer.Shadow>?
    var masksToBounds: MBinding<Bool>?
    var gestureRecognizers: MBinding<[UIGestureRecognizer]?>?
    
    /// Initialise the component view model with a binding that holds the text value.
    ///
    /// - Parameter binding: The binding that holds the text value.
    public init(_ binding: MBinding<String?>) {
        self._text = binding
    }

    /// Initialise the component view model with a binding that holds a non-optional text value.
    ///
    /// - Parameter nonOptionalBinding: The binding that holds the non-optional text value.
    public init(_ nonOptionalBinding: MBinding<String>) {
        self.init(MBinding(nonOptionalBinding))
    }

    /// Initialise the component view model with an optional text value.
    ///
    /// - Parameter text: The optional text value.
    public init(_ text: String? = nil) {
        self._text = .dynamic(text)
    }

    /// Initialise the component view model with a binding that holds the attributed text value.
    ///
    /// - Parameter attributedTextBinding: The binding that holds the attributed text value.
    public init(_ attributedTextBinding: MBinding<NSAttributedString?>) {
        self._attributedText = attributedTextBinding
    }

    /// Initialise the component view model with a binding that holds a non-optional attributed text value.
    ///
    /// - Parameter nonOptionalAttributedTextBinding: The binding that holds the non-optional attributed text value.
    public init(_ nonOptionalAttributedTextBinding: MBinding<NSAttributedString>) {
        self.init(MBinding(nonOptionalAttributedTextBinding))
    }

    /// Initialise the component view model with an optional attributed text value.
    ///
    /// - Parameter attributedText: The optional attributed text value.
    public init(_ attributedText: NSAttributedString?) {
        self._attributedText = .dynamic(attributedText)
    }

    /// Initialise the component view model with a attributed text builder.
    ///
    /// - Parameter builder: The attributed text builder.
    public init(@TextAttributedBuilder _ builder: () -> NSAttributedString) {
        self._attributedText = .dynamic(builder())
    }
}

public final class MTextView: UILabel {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension MTextView: ReusableView {
    public func configure(with data: MText) {
        CancellableStorage(in: &cancellables) {
            data.$text.publisher.weakAssign(to: \.text, on: self)
            data.$attributedText.publisher
                .compactMap { $0 }
                .weakAssign(to: \.attributedText, on: self)
            data.$textAppearance.publisher
                .sink { [weak self] appearance in
                    self?.updateAppearance(appearance: appearance)
                    if let attributedText = data.attributedText {
                        self?.attributedText = attributedText
                    }
                }
        }
        
        applyDeclarativeCommon(model: data, to: self, cancellables: &cancellables)
    }

    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension MTextView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }

        font = appearance.font
        textColor = appearance.textColor
        adjustsFontSizeToFitWidth = appearance.adjustsFontSizeToFitWidth
        textAlignment = appearance.textAlignment
        numberOfLines = appearance.numberOfLines
        lineBreakMode = appearance.lineBreakMode
        minimumScaleFactor = appearance.minimumScaleFactor
        
        self.appearance = appearance
    }
}

extension MTextView {
    public struct Appearance: Equatable, Withable {
        public var adjustsFontSizeToFitWidth: Bool
        public var font: UIFont?
        public var textColor: UIColor?
        public var textAlignment: NSTextAlignment
        public var numberOfLines: Int
        public var lineBreakMode: NSLineBreakMode
        public var minimumScaleFactor: CGFloat
        
        public init(
            adjustsFontSizeToFitWidth: Bool = false,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            textAlignment: NSTextAlignment  = .left,
            numberOfLines: Int  = 1,
            lineBreakMode: NSLineBreakMode = .byTruncatingTail,
            minimumScaleFactor: CGFloat = 1
        ) {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            self.font = font
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.numberOfLines = numberOfLines
            self.lineBreakMode = lineBreakMode
            self.minimumScaleFactor = minimumScaleFactor
        }
    }
}

/// This protocol helps other components that want to use MText's declarative
/// behaviour to implement MText appearance. To do this, you need to define the MText
/// appearance in your components.
public protocol Textable {
    var textAppearance: MTextView.Appearance { get nonmutating set }
}

extension Textable {
    /// Sets the value of adjustsFontSizeToFitWidth property of the text appearance.
    /// Modifies the text appearance of the Self instance.
    ///
    /// - Parameter adjustsFontSizeToFitWidth: The value to set.
    /// - Returns: The modified Self instance.
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        textAppearance.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }

    /// Sets the font of the text appearance.
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Parameter font: The font to set.
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        textAppearance.font = font
        return self
    }

    /// Sets the text color of the text appearance.
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Parameter textColor: The text color to set.
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func textColor(_ textColor: UIColor) -> Self {
        textAppearance.textColor = textColor
        return self
    }

    /// Sets the text alignment of the text appearance.
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Parameter textAlignment: The text alignment to set.
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        textAppearance.textAlignment = textAlignment
        return self
    }

    /// Sets the number of lines of the text appearance.
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Parameter numberOfLines: The number of lines to set.
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func numberOfLines(_ numberOfLines: Int) -> Self {
        textAppearance.numberOfLines = numberOfLines
        return self
    }

    /// Sets the line break mode of the text appearance.
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Parameter lineBreakMode: The line break mode to set.
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        textAppearance.lineBreakMode = lineBreakMode
        return self
    }

    /// Centers and multiline text.
    /// It sets `textAlignment` to `.center` and `numberOfLines` to `.zero`
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func centerMultiline() -> Self {
        textAppearance.textAlignment = .center
        textAppearance.numberOfLines = .zero
        return self
    }

    /// Sets text multilined.
    /// It sets `numberOfLines` to `.zero`
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func multiline() -> Self {
        textAppearance.numberOfLines = .zero
        return self
    }
    
    /// Sets the minimum scale factor of the text appearance.
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Parameter minimumFontSize: The scale factor to set.
    /// - Returns: The minimumScaleFactor `Self` instance.
    @discardableResult
    public func minimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        textAppearance.minimumScaleFactor = minimumScaleFactor
        return self
    }
}

extension MText: Stylable {
    @discardableResult
    public func style(_ appearance: MTextView.Appearance) -> Self {
        self.textAppearance = appearance
        return self
    }
    
    public func appearance(_ appearance: MBinding<MTextView.Appearance>) -> Self {
        with(\._textAppearance, setTo: appearance)
    }
}
