//
//  HomeTableViewController.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/24/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import Firebase


struct Events {
    
    var eventname : String
    
    var description: String
    
    var imageur : String
    
}

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var loginOutbtn: UIBarButtonItem!
    
    
    private var Event = [Events]()
    private var items = [JSON](){
        didSet{
            tableView.reloadData()
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchEvents()
        
        nothingToShow()

    }
    
    func fetchEvents() {

        let db = Firestore.firestore()
        db.collection("event").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    
                    let Title = document.data()["eventTitle"] as? String
                    
                    let description = document.data()["discription"] as? String
                    
                    let imageurl =  document.data()["image"] as? String
                    
                  // let imageurl = document.data()["image"] as? String
                    
                    let events = Events(eventname: Title!, description: description!, imageur: imageurl!)
                    
                    self.Event.append(events)
                    
                    self.tableView.reloadData()
                    
                   print(events)
                }
            }
//
//            print(self.eventsArray) // <-- This prints the content in db correctly
            
            //            }
        }
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return Event.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        
        cell.evtitle.text = Event[indexPath.row].eventname
        cell.evdiscription.text = Event[indexPath.row].description


        let imageut = URL(string: Event[indexPath.row].imageur)
        cell.eventimage.kf.setImage(with: imageut)
        
//       
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlert(message:String)
    {
        
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func nothingToShow(){
        let lable = UILabel(frame: .zero)
        lable.textColor = UIColor.darkGray
        lable.numberOfLines = 0
        lable.text = " No articles to show"
        lable.textAlignment = .center
        tableView.separatorStyle = .none
        tableView.backgroundView = lable
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let sb = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! SignInViewController
            self.present(sb, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}
