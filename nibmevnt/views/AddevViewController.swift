//
//  AddevViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/22/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit

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
            let evnetTitle = evtitle.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let eventdicription = evdiscription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
       ////////////////////////////////////////////////////////
        //alert.dismiss(animated: false, completion: nil)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
        self.present(vc, animated: true, completion: nil)
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
