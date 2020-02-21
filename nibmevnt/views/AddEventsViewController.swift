//
//  AddEventsViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/21/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import Firebase

class AddEventsViewController: UIViewController {

    @IBOutlet weak var event: UITextField!
    @IBOutlet weak var place: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addbtn(_ sender: Any) {
        
        let events = event.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let palces = place.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        db.collection("event").addDocument(data: ["evnts":events,"places":palces])
    }
    

}
