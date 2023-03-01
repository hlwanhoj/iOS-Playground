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
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl1TrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lbl1.attributedText = createAttrString()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let val = slider.value
        coordinator.animate(alongsideTransition: { _ in
            self.updateLbl1TrailingConstraint(sliderValue: val, viewWidth: size.width)
        })
    }
    
    //

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
    
    private func updateLbl1TrailingConstraint(sliderValue: Float, viewWidth: CGFloat) {
        lbl1TrailingConstraint.constant = (1 - CGFloat(sliderValue)) * viewWidth * 3 / 4
    }
    
    @IBAction func onLbl1TrailingSliderValueChanged(_ sender: UISlider) {
        updateLbl1TrailingConstraint(sliderValue: sender.value, viewWidth: view.frame.width)
    }
}
