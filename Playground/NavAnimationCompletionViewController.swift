//
//  NavAnimationCompletionViewController.swift
//  Playground
//
//  Created by Ho Lun Wan on 26/1/2023.
//

import UIKit
import TinyConstraints
import Then

class NavAnimationCompletionViewController: UIViewController {
    @IBOutlet var pushVCButton: UIButton!
    @IBOutlet var popVCButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    private var innerNav: UINavigationController?
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = " "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "innerNav", let vc = segue.destination as? UINavigationController {
            innerNav = vc
        }
    }
    
    private func createNavChildVC() -> UIViewController {
        UIViewController().then {
            $0.view.backgroundColor = UIColor.systemYellow
        }
    }
    
    private func enableButtons() {
        pushVCButton.isEnabled = true
        popVCButton.isEnabled = true
    }
    
    private func disableButtons() {
        pushVCButton.isEnabled = false
        popVCButton.isEnabled = false
    }

    
    //
    
    @IBAction func onTapPushVCButton(_ sender: UIButton) {
        disableButtons()
        statusLabel.text = "Pushing..."
        innerNav?.pushViewController(createNavChildVC(), animated: true, completion: { [weak self] in
            self?.statusLabel.text = "Push completed"
            self?.enableButtons()
        })
    }
    
    @IBAction func onTapPopVCButton(_ sender: UIButton) {
        disableButtons()
        statusLabel.text = "Popping..."
        innerNav?.popViewController(animated: true, completion: { [weak self] in
            self?.statusLabel.text = "Pop completed"
            self?.enableButtons()
        })
    }
}
