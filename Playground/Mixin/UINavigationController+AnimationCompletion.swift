//
//  UINavigationController+AnimationCompletion.swift
//  Playground
//
//  Created by Ho Lun Wan on 26/1/2023.
//

import UIKit

extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    @discardableResult
    func popViewController(
        animated: Bool,
        completion: @escaping () -> Void
    ) -> UIViewController? {
        let vc: UIViewController? = popViewController(animated: animated)
        
        guard animated, vc != nil, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return vc
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
        return vc
    }
    
    @discardableResult
    func popToViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void
    ) -> [UIViewController]? {
        let vcs: [UIViewController]? = popToViewController(viewController, animated: animated)

        guard animated, vcs != nil, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return vcs
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
        return vcs
    }
    
    @discardableResult
    func popToRootViewController(animated: Bool, completion: @escaping () -> Void) -> [UIViewController]? {
        let vcs: [UIViewController]? = popToRootViewController(animated: animated)

        guard animated, vcs != nil, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return vcs
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
        return vcs
    }
    
    func setViewControllers(
        _ viewControllers: [UIViewController],
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        setViewControllers(viewControllers, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
