//
//  ViewController.swift
//  MaxUIExample
//
//  Created by Maksim Kudriavtsev on 25/01/2023.
//

import MaxUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

extension ViewController {
    private func setupLayout() {
        view.backgroundColor = .white
        title = "MaxUI Examples"
        navigationController?.navigationBar.prefersLargeTitles = true
        ScrollView {
            VStack {
                for screen in Screen.exampleScreens {
                    HStack {
                        VStack {
                            HStack {
                                Text(screen.title)
                                Spacer(width: 5)
                                Text(screen.componentName)
                                    .font(.systemFont(ofSize: 20, weight: .bold))
                                Spacer()
                            }
                            Text(screen.description)
                                .font(.systemFont(ofSize: 14))
                                .textColor(.gray)
                                .multiline()
                        }
                        .spacing(10)
                        Spacer()
                        Image(UIImage(systemName: "chevron.right"))
                            .tintColor(.lightGray)
                    }
                    .spacing(4)
                    .backgroundColor(.white)
                    .shadow(offsetY: 4, color: .black, opacity: 0.1, radius: 5)
                    .cornerRadius(12)
                    .insets(24)
                    .borderWidth(1 / UIScreen.main.scale)
                    .toContainer()
                    .insets(vertical: 8)
                    .onSelect { [weak self] in
                        self?.navigationController?.present(screen.viewController, animated: true)
                    }
                }
            }
            .insets(horizontal: 16)
        }
        .configure(in: view, safeArea: true)
    }
}

extension ViewController {
    private struct Screen {
        let title: String
        let componentName: String
        let description: String
        let viewController: UIViewController
        
        static let exampleScreens = [
            Screen(
                title: "Let's try",
                componentName: "Text",
                description: "This is the example how to use Text component.",
                viewController: TextExampleViewController()
            ),
            Screen(
                title: "Let's try",
                componentName: "Button",
                description: "This is the example how to use Button component.",
                viewController: ButtonExampleViewController()
            )
        ]
    }
}

#if DEBUG
import SwiftUI
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ViewController()
        }
    }
}
#endif
