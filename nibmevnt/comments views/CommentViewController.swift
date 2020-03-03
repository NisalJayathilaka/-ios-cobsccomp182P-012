//
//  CommentViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 3/3/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

struct Commnts {
    
    var Commtitle : String
    
    var Commnt: String
    
}

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    private var Comt = [Commnts]()
    private var items = [JSON](){
        didSet{
            tblcommt.reloadData()
        }
    }
    
    
    
    
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtcomt: UITextField!
    @IBOutlet weak var ErrorLable: UILabel!
    @IBOutlet weak var tblcommt: UITableView!
    
    var comments = [CommModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        fetchEvents()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func setUpElements(){
        ErrorLable.alpha=0
    }
    
    func validateFields() -> String? {
        
        if txtname.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtcomt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "please fill in all fields."
        }
        
        return nil
    }
    
    
    @IBAction func AddCommnt(_ sender: Any) {
        
        let error = validateFields()
        if error != nil
        {
            showError(error!)
        }
        else{
            
            let db = Firestore.firestore()
            
            let evename = txtname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let evecommnt = txtcomt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let dt: [String: String] = ["eventTitle" : evename,
                                        "discription" : evecommnt
                //"eventid" : evntID
            ]
            
            db.collection("comment").addDocument(data: dt) {(error) in
                if (error != nil) {
                    print ("failed")
                } else {
                    print ("data added")
                    
                }
            }
            
            
        }
    }
    
    
    func showError(_ message:String) {
        self.ErrorLable.alpha = 1
        self.ErrorLable.text = message
    }
    
    
    func fetchEvents() {
        
        let db = Firestore.firestore()
        db.collection("comment").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    
                    let Title = document.data()["eventTitle"] as? String
                    
                    let description = document.data()["discription"] as? String
                    let events = Commnts(Commtitle: Title!, Commnt: description!)
                    
                    self.Comt.append(events)
                    
                    self.tblcommt.reloadData()
                    
                    print(events)
                }
            }
            
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Comt.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        cell.lblname.text = Comt[indexPath.row].Commtitle
        cell.lblcommt.text = Comt[indexPath.row].Commnt
        
        
        return cell
    }
}
