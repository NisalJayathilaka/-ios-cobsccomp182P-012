//
//  EventTableViewCell.swift
//  nibmevnt
//
//  Created by nisal jayathilaka on 2/24/20.
//  Copyright © 2020 nisal jayathilaka. All rights reserved.
//

import UIKit
import Kingfisher

class EventTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventimage: UIImageView!
    @IBOutlet weak var evtitle: UILabel!
    @IBOutlet weak var evdiscription: UILabel!
    
    var event: Event! {
        didSet {
            self.configCell()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        //eventimage.layer.cornerRadius = 5
        // Initialization code
    }
    
//    func configCell(catrgory: Event) {
//        evtitle.text = catrgory.eventTitle
//        evdiscription.text = catrgory.discription
//        if let url = URL(string: catrgory.image)
//        {
//            eventimage.kf.setImage(with: url)
//        }
//    }
    
    func configCell() {
        evtitle.text = event.eventTitle
        evdiscription.text = event.discription
        if let url = URL(string: event.image)
        {
            eventimage.kf.setImage(with: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
