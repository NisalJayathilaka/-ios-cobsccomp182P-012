//
//  ProfileViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/22/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profieimg: UIImageView!
    @IBOutlet weak var frstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var contactnum: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
         getuserdetails()
        // Do any additional setup after loading the view.
    }
    
 
    func getuserdetails() {
        
        
        guard let uid = Auth.auth().currentUser?.uid
            else{return}
        print(uid)
        let db = Firestore.firestore()
        let docRef = db.collection("user").document(uid)
        
        
        print(docRef)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document datta: \(dataDescription)")
                
                self.frstname.text = (document.get("firstname") as! String)
                self.lastname.text = (document.get("lastname") as! String)
                self.contactnum.text = (document.get("contact") as! String?)
                
                let propic = (document.get("image") as! String)
                self.profieimg.kf.setImage(with: URL(string: propic), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                
                
            } else {
                print("Document does not exist in cache")
            }
        }
       

        
        
    }
    

}
