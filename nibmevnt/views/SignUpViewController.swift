//
//  SignUpViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/20/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage




class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var phonenumber: UITextField!
    
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var signupbtn: UIButton!
    @IBOutlet weak var errorLable: UILabel!
    
     var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        profileImagePicker()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        errorLable.alpha=0
    }
    func validateFields() -> String? {
        
        if firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phonenumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passtxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            
        {
            return "please fill in all fields."
        }
        
        let cleanedPassword = passtxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false
        {
            return "  password least 8 carackters, special character and a number"
        }
        
        
        return nil
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil
        {
            showError(error!)
        }
        else
        {
            
            let firstName = firstname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailtxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = phonenumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipcode = passtxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil
                {
                    self.showError("error cretaing user")
                }
                else{
                    let db = Firestore.firestore()
                    
                    let stroageRef = Storage.storage().reference(forURL: "gs://nevents-c2256.appspot.com").child("profile_image").child(result!.user.uid)
                    if let profileImage = self.selectedImage, let imageData = profileImage.jpegData(compressionQuality: 0.1)
                    {
                        stroageRef.putData(imageData, metadata: nil, completion: { (metadata, error ) in
                            if error != nil{
                                self.showError("Error in uploading profile photo.")
                            }


                        })

                    }
                    
                    
                    
                    ////////////////////////////////////////
                    db.collection("user").addDocument(data:
                        
                    ["firstname" : firstName,
                     "lastname" : lastName,
                     "email" : email,
                     " zipcode" : zipcode,
                     "uid" : result!.user.uid])
                    { (error) in
                        
                        if error != nil {
                            self.showError("error saving user data")
                        }
                    }
                    self.movetohome()
                }
                
            }
        }
        
        
    }
    
    
    func showError(_ message:String) {
        self.errorLable.alpha = 1
        self.errorLable.text = message
    }
    func movetohome() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constans.Storyboard.homeViewController) as?
        HOViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
        
    }
    
    func profileImagePicker(){
        
        profilepic.layer.cornerRadius = 40
        profilepic.clipsToBounds = true
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profilepic.addGestureRecognizer(tapGuesture)
        profilepic.isUserInteractionEnabled = true
    }
    @objc func handleSelectProfileImageView()
    {
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        present(imagepickercontroller, animated: true, completion: nil)
        //print("tapped")
    }
    
    
    
        
}
    
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profilepic.image = image
        }
        print(info)
        
        dismiss(animated: true, completion: nil)
    }
}


