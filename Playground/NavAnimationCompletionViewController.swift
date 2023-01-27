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
    @IBOutlet var popToRootButton: UIButton!
    @IBOutlet var set5VCsButton: UIButton!
    @IBOutlet var popTo2ndVCButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    private var innerNav: UINavigationController?
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = " "
        enableButtons()
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
        popToRootButton.isEnabled = true
        set5VCsButton.isEnabled = true
        popTo2ndVCButton.isEnabled = (innerNav?.viewControllers.count ?? 0) > 1
    }
    
    private func disableButtons() {
        pushVCButton.isEnabled = false
        popVCButton.isEnabled = false
        popToRootButton.isEnabled = false
        set5VCsButton.isEnabled = false
        popTo2ndVCButton.isEnabled = false
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
    
    @IBAction func onTapPopToRootButton(_ sender: UIButton) {
        disableButtons()
        statusLabel.text = "Popping..."
        innerNav?.popToRootViewController(animated: true, completion: { [weak self] in
            self?.statusLabel.text = "Pop completed"
            self?.enableButtons()
        })
    }
    
    @IBAction func onTapSet5VCsButton(_ sender: UIButton) {
        disableButtons()
        statusLabel.text = "Setting 5 view controllers..."

        let vcs: [UIViewController] = [
            createNavChildVC().then { $0.view.backgroundColor = .systemRed },
            createNavChildVC(),
            createNavChildVC(),
            createNavChildVC(),
            createNavChildVC(),
        ]
        innerNav?.setViewControllers(vcs, animated: true, completion: { [weak self] in
            self?.statusLabel.text = "Set completed"
            self?.enableButtons()
        })
    }
    
    @IBAction func onTapPopTo2ndVCButton(_ sender: UIButton) {
        disableButtons()
        statusLabel.text = "Popping..."
        
        let vcs: [UIViewController] = innerNav?.viewControllers ?? []
        if vcs.count > 1 {
            let vc = vcs[1]
            innerNav?.popToViewController(vc, animated: true, completion: { [weak self] in
                self?.statusLabel.text = "Pop completed"
                self?.enableButtons()
            })
        }
    }
}
