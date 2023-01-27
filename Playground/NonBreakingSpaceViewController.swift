//
//  ViewController.swift
//  Playground
//
//  Created by Ho Lun Wan on 19/1/2023.
//

import UIKit
import TinyConstraints
import Then

class NonBreakingSpaceViewController: UIViewController {
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl1TrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lbl1.attributedText = createAttrString()
    }

    private func createAttrString() -> NSAttributedString {
        let font: UIFont = UIFont(name: "Avenir Next Regular", size: 12)!
        let attrStr: NSMutableAttributedString = NSMutableAttributedString()
        attrStr.append(
            NSAttributedString(string: "Label Title: ", attributes: [
                .font: font,
            ])
        )

        let v: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.".replacingOccurrences(of: " ", with: "\u{00A0}")
        attrStr.append(
            NSAttributedString(string: v, attributes: [
                .font: font,
                .foregroundColor: UIColor.systemRed,
            ])
        )
        return attrStr
    }
    
    @IBAction func onLbl1TrailingSliderValueChanged(_ sender: UISlider) {
        lbl1TrailingConstraint.constant = (1 - CGFloat(sender.value)) * view.frame.width * 3 / 4
    }
}
