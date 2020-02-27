//
//  SignInViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/20/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailtxt: UITextField!
    
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var signinbtn: UIButton!
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var forgetpassbtn: UIButton!
    
    @IBOutlet weak var signupbtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupelments()
     // self.configurecomponents()
    }
    
    func setupelments() {
        errorLable.alpha=0
    }
    
    func configurecomponents() {
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                let naController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarViewController
                self.present(naController, animated: true, completion: nil)

            }
        }
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        
//
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        self.present(alert, animated: true, completion: nil)
        ////////////////////////////////////////////////////////////////////////
        
        let email = emailtxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passtxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorLable.alpha = 1
                self.errorLable.text = error!.localizedDescription
            }
            else
            {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarViewController
                appDelegate.window?.rootViewController = yourVC
                appDelegate.window?.makeKeyAndVisible()
                
                
            }
        }
        
        
        
    }
    
}
