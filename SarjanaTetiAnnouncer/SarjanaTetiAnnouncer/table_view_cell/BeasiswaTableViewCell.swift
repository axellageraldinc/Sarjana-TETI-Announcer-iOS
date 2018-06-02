//
//  BeasiswaTableViewCell.swift
//  SarjanaTetiAnnouncer
//
//  Created by Axellageraldinc Adryamarthanino on 01/06/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class BeasiswaTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDeadline: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    let cellBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    let cardViewBackgroundColor = UIColor.white
    let cardViewCornerRadius = 3.0
    let cardViewShadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    let cardViewShadowOffset = CGSize(width: 0, height: 0)
    let cardViewShadowOpacity = 0.8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = CGFloat(cardViewCornerRadius)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = cardViewShadowColor
        cardView.layer.shadowOffset = cardViewShadowOffset
        cardView.layer.shadowOpacity = Float(cardViewShadowOpacity)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
