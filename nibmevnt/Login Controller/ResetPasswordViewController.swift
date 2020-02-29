//
//  ResetPasswordViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/20/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetpass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func resetPassBtn(_ sender: Any) {
        
        
        Auth.auth().sendPasswordReset(withEmail: resetpass.text!) { error in
            DispatchQueue.main.async {
                if error != nil {
                    
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                    // YOUR ERROR CODE
                } else {
                    
                    let resetEmailAlertSent = UIAlertController(title: "Reset Email Sent", message: "Reset email has been sent to your login email, please follow the instructions in the mail to reset your password", preferredStyle: .alert)
                    resetEmailAlertSent.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailAlertSent, animated: true, completion: nil)
                    //YOUR SUCCESS MESSAGE
                }
            }
        }
    }
    
}
