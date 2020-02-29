//
//  AddevViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/22/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class AddevViewController: UIViewController {
    
    
    @IBOutlet weak var evntImage: UIImageView!
    @IBOutlet weak var evtitle: UITextField!
    @IBOutlet weak var evdiscription: UITextField!
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
        
        if evtitle.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            evdiscription.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "please fill in all fields."
        }
        
        return nil
    }
    
    
    
    func profileImagePicker(){
        
        evntImage.layer.cornerRadius = 10
        evntImage.clipsToBounds = true
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(AddevViewController.handleSelectProfileImageView))
        evntImage.addGestureRecognizer(tapGuesture)
        evntImage.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView()
    {
        let imagepickercontroller = UIImagePickerController()
        imagepickercontroller.delegate = self
        present(imagepickercontroller, animated: true, completion: nil)
        //print("tapped")
    }
    
    
    @IBAction func addEventTapped(_ sender: Any) {
        ////////////////////////////////////////////////////////
        
        let error = validateFields()
        if error != nil
        {
            showError(error!)
        }
        else{
            let db = Firestore.firestore()
            
            let evnetTitle = evtitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let eventdicription = evdiscription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let uid = Auth.auth().currentUser?.uid
                else{return}
            print(uid)
            let stroageRef = Storage.storage().reference(forURL: "gs://nevents-c2256.appspot.com").child("Event_image").child(uid)
            
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
                            
                            
                            let dt: [String: String] = ["eventTitle" : evnetTitle,
                                                        "discription" : eventdicription,
                                                        "image" : metaImageUrl,
                                                        "userid" : uid,
                                                        
                                                        
                            ]
                           // let evid = db.collection("event").document(uid)
                            db.collection("event").addDocument(data: dt) {(error) in
                                if (error != nil) {
                                    print ("failed")
                                } else {
                                    print ("data added")
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                                    self.present(vc, animated: true, completion: nil)
                                    
                                }
                            }
                            
                        }
                    })
                    
                })
                
            }
            
            
        }
        ////////////////////////////////////////////////////////
        //alert.dismiss(animated: false, completion: nil)
        
    }
    
    
    func showError(_ message:String) {
        self.errorLable.alpha = 1
        self.errorLable.text = message
    }
}

extension AddevViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            evntImage.image = image
        }
        print(info)
        
        dismiss(animated: true, completion: nil)
    }
}
