//
//  TabBarController.swift
//  NewsApp
//
//  Created by Vitaly on 30.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.tintColor = .white
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            setupNavigationController(rootViewController: GeneralViewController(viewModel: GeneralViewModel()), title: "General", image: UIImage(systemName: "newspaper") ?? UIImage.add),
            setupNavigationController(rootViewController: BusinessViewController(viewModel: BusinessViewModel()), title: "Business", image: UIImage(systemName: "briefcase") ?? UIImage.add),
            setupNavigationController(rootViewController: TechnologyViewController(viewModel: TechnologyViewModel()), title: "Technology", image: UIImage(systemName: "gyroscope") ?? UIImage.add)
        ]
    }
    
    private func setupNavigationController(rootViewController: UIViewController,
                                           title: String,
                                           image: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        rootViewController.title = title
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
}
