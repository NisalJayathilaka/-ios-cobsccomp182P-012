//
//  UserInfoViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/27/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var fname: UILabel!
    @IBOutlet weak var lname: UILabel!
    @IBOutlet weak var contact: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userinfomation()
        // Do any additional setup after loading the view.
    }
    
    func userinfomation() {
        
        
        
        guard let uid = Auth.auth().currentUser?.uid
            else{return}
        print(uid)
        let db = Firestore.firestore()
        let docRef = db.collection("user").document(uid)
        
        
        print(docRef)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                self.fname.text = (document.get("firstname") as! String)
                self.lname.text = (document.get("lastname") as! String)
                self.contact.text = (document.get("contact") as! String)
                
                
                let propic = (document.get("image") as! String)
                self.userimg.kf.setImage(with: URL(string: propic), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                
                
            } else {
                print("Document does not exist in cache")
            }
        }
        
    }
  

}
