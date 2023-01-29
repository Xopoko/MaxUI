import SwiftUI

public struct UIViewControllerPreview: UIViewControllerRepresentable {
    public let viewController: UIViewController

    public init(_ builder: @escaping () -> UIViewController) {
        viewController = builder()
    }
    
    // MARK: UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> UIViewController { viewController }
   
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

public struct UIViewPreview: UIViewRepresentable {
    public let view: UIView
    
    public init(_ builder: @escaping () -> UIView) {
        view = builder()
    }
    
    // MARK: UIViewRepresentable
    public func makeUIView(context: Context) -> UIView { view }
    
    public func updateUIView(_ view: UIView, context: Context) {}
}

public struct ComponentPreview: UIViewRepresentable {
    public enum Distribution {
        case fill, center, top
    }
    
    public let view: ViewableViewModelProtocol
    private let distribution: Distribution
    
    public init(
        distribution: Distribution = .center,
        _ builder: @escaping () -> ViewableViewModelProtocol
    ) {
        view = builder()
        self.distribution = distribution
    }
    
    // MARK: UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        switch distribution {
        case .center:
            return ScrollView {
                view
            }
            .distribution(.center(offset: .zero))
            .createAssociatedViewInstance()
        case .fill:
            return view.createAssociatedViewInstance()
        case .top:
            return VStack {
                view
                Spacer()
            }
            .createAssociatedViewInstance()
        }
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
        view.fill()
    }
}

extension View {
    public func previewDevice(_ value: AvailablePreviewDevice) -> some View {
        self.previewDevice(PreviewDevice(rawValue: value.rawValue))
            .previewDisplayName(value.rawValue)
    }
}

public enum AvailablePreviewDevice: String {
    case iPhone8 = "iPhone 8"
    case iPhone8Plus = "iPhone 8 Plus"
    case iPhoneX = "iPhone X"
    case iPhoneXs = "iPhone Xs"
    case iPhoneXsMax = "iPhone Xs Max"
    case iPhoneXʀ = "iPhone Xʀ"
    case iPhone11 = "iPhone 11"
    case iPhone11Pro = "iPhone 11 Pro"
    case iPhone11ProMax = "iPhone 11 Pro Max"
    case iPhoneSE2ndGeneration = "iPhone SE (2nd generation)"
    case iPhone12mini = "iPhone 12 mini"
    case iPhone12 = "iPhone 12"
    case iPhone12Pro = "iPhone 12 Pro"
    case iPhone12ProMax = "iPhone 12 Pro Max"
    case iPhone13Pro = "iPhone 13 Pro"
    case iPhone13ProMax = "iPhone 13 Pro Max"
    case iPhone13mini = "iPhone 13 mini"
    case iPhone13 = "iPhone 13"
    case iPhoneSE3rdGeneration = "iPhone SE (3rd generation)"
    case iPhone14 = "iPhone 14"
    case iPhone14Plus = "iPhone 14 Plus"
    case iPhone14Pro = "iPhone 14 Pro"
    case iPhone14ProMax = "iPhone 14 Pro Max"
}

public let previewDevices: [AvailablePreviewDevice] = [.iPhone14, .iPhone8]
