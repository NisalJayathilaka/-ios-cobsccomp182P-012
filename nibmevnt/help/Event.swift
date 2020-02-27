//
//  Event.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/25/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import Foundation
import FirebaseFirestore
struct Event {
    
    
    var discription: String
    var eventTitle: String
    var image: String
    var userid: String
//
//
//
//    var dictionary:[String:Any]
//    {
//        return[
//            "discription":discription,
//            "eventTitle":eventTitle,
//            "image":image
//
//        ]
//    }
}

//extension Event
//{
//    init?(dictionary:[String:Any],id: String) {
//        guard let discription = dictionary["dictionary"] as? String,
//        guard let eventTitle = dictionary["eventTitle"] as? String,
//        guard let image = dictionary["image"] as? String
//            else{return nil}
//
//        self.init(discription: discription, eventTitle: eventTitle, image: image, userid: id)
//    }
//}
