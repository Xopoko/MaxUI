//
//  ButtonExampleViewController.swift
//  MaxUIExample
//
//  Created by Maksim Kudriavtsev on 29/01/2023.
//

import MaxUI

class ButtonExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        MScrollView {
            MVStack {
                containerForExample("Just a button") {
                    MButton("Button 1") {
                        print("tap on Button 1")
                    }
                }
                containerForExample("Button with .background(.systemBlue)") {
                    MButton("Button 2") {
                        print("tap on Button 2")
                    }
                    .backgroundColor(.systemBlue)
                }
                
                containerForExample("Pro Max Ultra Button") {
                    MButton {
                        print("tap on Pro Max Ultra Button")
                    } label: {
                        MHStack {
                            MSpacer()
                            MText("🎉")
                            MText("Hello, comrads")
                                .textColor(.white)
                                .font(.systemFont(ofSize: 20, weight: .semibold))
                            MImage(UIImage(systemName: "brain.head.profile"))
                                .tintColor(.white)
                            MSpacer()
                        }
                        .spacing(10)
                    }
                    .height(44)
                    .gradient(
                        layer: .init(cornerRadius: 8, masksToBounds: true),
                        colors: [
                            UIColor(red: 0.00, green: 0.86, blue: 0.87, alpha: 1.00),
                            UIColor(red: 0.99, green: 0.00, blue: 1.00, alpha: 1.00)
                        ]
                    )
                    .shadow(
                        offsetX: 4,
                        offsetY: 4,
                        color: UIColor(red: 0.99, green: 0.00, blue: 1.00, alpha: 1.00),
                        opacity: 0.3,
                        radius: 5
                    )
                    .insets(24)
                }
                
                containerForExample("Button with .insets(24). As you see, it becomes just bigger. Because insets works only on subview of container. Subview of Button here is just a Text.") {
                    MButton("Button 3") {
                        print("tap on Button 3")
                    }
                    .backgroundColor(.systemBlue)
                    .insets(24)
                }
                containerForExample("To set 'real' insets you have to wrap button to another container. You can ask me 'Why?' So the answer is: just deal with it! This library constructed on containers. And the best thing i made, create button as child of text and container. May be in future, i'll change it...") {
                    MButton("Button 4") {
                        print("tap on Button 4")
                    }
                    .backgroundColor(.systemGreen)
                    .toContainer()
                    .insets(horizontal: 24)
                }
                
             
            }
            .spacing(10)
        }
        .configure(in: view, safeArea: true)
    }
    
    private func containerForExample(_ explanation: String, _ builder: () -> MView) -> MView {
        MVStack {
            MText(explanation)
                .centerMultiline()
                .insets(16)
            MImage(UIImage(systemName: "chevron.down"))
                .tintColor(.black)
            MSpacer(height: 20)
            MVStack {
                builder()
            }
        }
        .borderWidth(1)
        .cornerRadius(8)
        .toContainer()
        .insets(horizontal: 16)
    }
}

#if DEBUG
import SwiftUI
struct ButtonExampleViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ButtonExampleViewController()
        }
    }
}
#endif
