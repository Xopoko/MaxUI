//
//  TextExampleViewController.swift
//  MaxUIExample
//
//  Created by Maksim Kudriavtsev on 28/01/2023.
//

import MaxUI

class TextExampleViewController: UIViewController {
    @MaxUI.State var stateExample: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ScrollView {
            VStack {
                Text("This is just a text without a modifiers")
                Divider()
                Text("This is a text with several modifiers")
                    .font(.systemFont(ofSize: 20, weight: .light))
                    .textColor(.lightGray)
                    .textAligment(.right)
                    .numberOfLines(1)
                    .adjustsFontSizeToFitWidth(true)
                Divider()
                Text("It's a long, multi-line script. Obviously, I'm going to use Lorem ipsum. I'm sorry...\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .multiline()
                Divider()
                Text("Let's try to use")
                    .textAligment(.center)
                Text("@State")
                    .textAligment(.center)
                    .font(.systemFont(ofSize: 16, weight: .bold))
                Text("(just tap on this text)")
                    .textAligment(.center)
                    .textColor(.systemBlue)
                    .borderWidth(1)
                    .borderColor(.systemBlue)
                    .insets(8)
                    .cornerRadius(8)
                    .onSelect { [weak self] in
                        self?.stateExample = "\(String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!))"
                    }
                Text($stateExample)
                    .textAligment(.center)
                    .font(.systemFont(ofSize: 40, weight: .bold))
                
                Divider()
                Text {
                    "Just a link"
                        .foregroundColor(.systemBlue)
                        .underlineStyle(.single)
                        .underlineColor(.systemBlue)
                    
                    " (Please don't touch)"
                }
                .onSelect(animation: .alpha) {
                    UIApplication.shared.open(URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!)
                }
                Divider()
                Text {
                    "To show you additional "
                    "Text"
                        .font(.systemFont(ofSize: 20, weight: .bold))
                        .foregroundColor(.blue)
                        .kern(3)
                    " component capabilities, I just tell you a joke 🤡"
                    "\n"
                    "\n"
                    "> "
                        .font(.systemFont(ofSize: 20, weight: .bold))
                    "How to find an iOS developer in the crowd?"
                    "\n"
                    "\n"
                    "> "
                        .font(.systemFont(ofSize: 20, weight: .bold))
                    "Use Debug View Hierarchy :):):):)"
                    "\n"
                    "🤡"
                        .font(.systemFont(ofSize: 400))
                        .alignment(.center)
                    "\n"
                    "\n"
                    "(I know it's cringe but I'm dead inside and I don't care)"
                        .font(.systemFont(ofSize: 12))
                        .foregroundColor(.lightGray)
                        .alignment(.center)
                }
                .multiline()
                Divider()
            }
            .spacing(20)
            .insets(24)
        }
        .configure(in: view, safeArea: true)
    }
}

#if DEBUG
import SwiftUI
struct TextExampleViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            TextExampleViewController()
        }
    }
}
#endif
