//
//  WelcomeViewController.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .green
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 20, y: view.height - 50 - view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func handleSignIn(success: Bool) {
        // Log in success or failure
        getCurrentUserProfile { success in
            guard success else {
                let alert = UIAlertController(title: "Oops",
                                              message: "Something went wrong",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                return
            }
            
            DispatchQueue.main.async {
                let mainAppTabBarVC = TabBarViewController()
                mainAppTabBarVC.modalPresentationStyle = .fullScreen
                self.present(mainAppTabBarVC, animated: true)
            }
            
        }
    }
    
    private func getCurrentUserProfile(completion: @escaping (Bool) -> Void) {
        APICaller.shared.getCurrentUserProfile { response in
            switch(response) {
                case .success(let model):
                    debugPrint("Successfully fetched user profile")
                    UserDefaults.standard.setValue(model.id, forKey: "user_id")
                    completion(true)
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    completion(true)
            }
        }
    }
}
