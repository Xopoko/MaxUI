import UIKit
import Combine

/// A component view model struct that represents a text component and conforms to the
/// Componentable and Textable protocols.
public struct MText: Componentable, Textable {
    /// The type of the view that represents the component view model.
    public typealias ViewType = MTextView

    /// A binding that holds the text value.
    @MBinding public var text: String?
    /// A binding that holds the text appearance value.
    @MBinding public var textAppearance = MTextView.Appearance()
    /// A binding that holds the attributed text value.
    @MBinding public var attributedText: NSAttributedString?

    /// Initializes the component view model with a binding that holds the text value.
    ///
    /// - Parameter binding: The binding that holds the text value.
    public init(_ binding: MBinding<String?>) {
        self._text = binding
    }

    /// Initializes the component view model with a binding that holds a non-optional text value.
    ///
    /// - Parameter nonOptionalBinding: The binding that holds the non-optional text value.
    public init(_ nonOptionalBinding: MBinding<String>) {
        self.init(MBinding(nonOptionalBinding))
    }

    /// Initializes the component view model with an optional text value.
    ///
    /// - Parameter text: The optional text value.
    public init(_ text: String? = nil) {
        self._text = .dynamic(text)
    }

    /// Initializes the component view model with a binding that holds the attributed text value.
    ///
    /// - Parameter attributedTextBinding: The binding that holds the attributed text value.
    public init(_ attributedTextBinding: MBinding<NSAttributedString?>) {
        self._attributedText = attributedTextBinding
    }

    /// Initializes the component view model with a binding that holds a non-optional attributed text value.
    ///
    /// - Parameter nonOptionalAttributedTextBinding: The binding that holds the non-optional attributed text value.
    public init(_ nonOptionalAttributedTextBinding: MBinding<NSAttributedString>) {
        self.init(MBinding(nonOptionalAttributedTextBinding))
    }

    /// Initializes the component view model with an optional attributed text value.
    ///
    /// - Parameter attributedText: The optional attributed text value.
    public init(_ attributedText: NSAttributedString?) {
        self._attributedText = .dynamic(attributedText)
    }

    /// Initializes the component view model with a attributed text builder.
    ///
    /// - Parameter builder: The attributed text builder.
    public init(@TextAttibutedBuilder _ builder: () -> NSAttributedString) {
        self._attributedText = .dynamic(builder())
    }
}

public final class MTextView: UILabel {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension MTextView: ReusableView {
    public func configure(with data: MText) {
        data.$text.publisher
            .assign(to: \.text, on: self)
            .store(in: &cancellables)

        data.$attributedText.publisher
            .compactMap { $0 }
            .assign(to: \.attributedText, on: self)
            .store(in: &cancellables)

        data.$textAppearance.publisher
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
                if let attributedText = data.attributedText {
                    self?.attributedText = attributedText
                }
            }
            .store(in: &cancellables)
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
        textAlignment = appearance.textAligment
        numberOfLines = appearance.numberOfLines
        lineBreakMode = appearance.lineBreakMode

        self.appearance = appearance
    }
}

extension MTextView {
    public struct Appearance: Equatable, Withable {
        public var adjustsFontSizeToFitWidth: Bool
        public var font: UIFont?
        public var textColor: UIColor?
        public var textAligment: NSTextAlignment
        public var numberOfLines: Int
        public var lineBreakMode: NSLineBreakMode

        public init(
            adjustsFontSizeToFitWidth: Bool = false,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            textAligment: NSTextAlignment  = .left,
            numberOfLines: Int  = 1,
            lineBreakMode: NSLineBreakMode = .byTruncatingTail
        ) {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            self.font = font
            self.textColor = textColor
            self.textAligment = textAligment
            self.numberOfLines = numberOfLines
            self.lineBreakMode = lineBreakMode
        }
    }
}

/// This protocol helps other components that want to use MText's declarative
/// behavior to implement MText apperance. To do this, you need to define the MText
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
    /// - Parameter textAligment: The text alignment to set.
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func textAligment(_ textAligment: NSTextAlignment) -> Self {
        textAppearance.textAligment = textAligment
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
    /// It sets `textAligment` to `.center` and `numberOfLines` to `.zero`
    /// Modifies the text appearance of the `Self` instance.
    ///
    /// - Returns: The modified `Self` instance.
    @discardableResult
    public func centerMultiline() -> Self {
        textAppearance.textAligment = .center
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
}

extension MText: Stylable {
    @discardableResult
    public func style(_ appearance: MTextView.Appearance) -> Self {
        self.textAppearance = appearance
        return self
    }
}
