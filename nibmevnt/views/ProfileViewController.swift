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
    @IBOutlet weak var errorLable: UILabel!
   // @IBOutlet weak var useremail: UITextField!
    @IBOutlet weak var useremail: UILabel!
    
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
         getuserdetails()
         setUpElements()
        profileImagePicker()
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
                print("Document data: \(dataDescription)")
                
                self.frstname.text = (document.get("firstname") as! String)
                self.lastname.text = (document.get("lastname") as! String)
                self.contactnum.text = (document.get("contact") as! String)
                 self.useremail.text = (document.get("email") as! String)
                
                
                let propic = (document.get("image") as! String)
                self.profieimg.kf.setImage(with: URL(string: propic), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                
                
            } else {
                print("Document does not exist in cache")
            }
        }

    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func setUpElements(){
        errorLable.alpha=0
    }
    
    func validateFields() -> String? {
        
        if frstname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            contactnum.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" 
            
        {
            return "please fill in all fields."
        }
        
        return nil
    }
    
    func profileImagePicker(){
        
        profieimg.layer.cornerRadius = 10
        profieimg.clipsToBounds = true
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(AddevViewController.handleSelectProfileImageView))
        profieimg.addGestureRecognizer(tapGuesture)
        profieimg.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView()
    {
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        present(imagepickercontroller, animated: true, completion: nil)
        //print("tapped")
    }
    
    
    @IBAction func upprofileTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil
        {
            showError(error!)
        }
        else{
            let db = Firestore.firestore()
            
            let fisrtname = frstname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lasname = lastname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contact = contactnum.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let uemail = useremail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let uid = Auth.auth().currentUser?.uid
                else{return}
            print(uid)
            
            let stroageRef = Storage.storage().reference(forURL: "gs://nevents-c2256.appspot.com").child("profile_image").child(uid)
            
             if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1)
             {
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                
                
                stroageRef.putData(imageData, metadata: metaData, completion: { (metadata, error ) in
                    if error != nil{
                        self.showError("Error in uploading profile photo.")
                    }
                    
                    stroageRef.downloadURL(completion: { (url, error) in
                        if let metaImageUrl = url?.absoluteString{
                            print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
                            print(metaImageUrl)
                            
                            db.collection("user").document(uid).setData(
                                
                                ["firstname" : fisrtname,
                                 "lastname" : lasname,
                                 "email" : uemail,
                                 "contact" : contact,
                                 "image" : metaImageUrl,
                                 "userid" : uid
                                ])
                            { (error) in
                                
                                if error != nil {
                                    self.showError("error saving user data")
                                }
                            }
                            
                        }
                    })
                    
                })
            }
        }
        
        ////////////////////////////////////////////////////////////////////////////////////
    }
    
    func showError(_ message:String) {
        self.errorLable.alpha = 1
        self.errorLable.text = message
    }
    
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profieimg.image = image
        }
        print(info)
        
        dismiss(animated: true, completion: nil)
    }
}
