//
//  TabBarViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/23/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import BiometricAuthentication

class TabBarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: ProfileViewController.self) {
            print("nannnnnnnnnnnnnn")
            BioMetricAuthenticator.authenticateWithBioMetrics(reason: "Authentication required to access this section") { (result) in
                
                switch result {
                case .success( _):
                    print("Authentication Successful")
                    self.selectedIndex = 1
                case .failure(let error):
                    print("Authentication Failed")
                    
                }
            }
            return false
        }
        return true
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("eeeee--\(item.tag)")
        
    }
    

}
