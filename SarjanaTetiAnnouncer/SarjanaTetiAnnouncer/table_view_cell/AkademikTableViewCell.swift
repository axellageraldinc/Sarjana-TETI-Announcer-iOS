//
//  AkademikTableViewCell.swift
//  SarjanaTetiAnnouncer
//
//  Created by Axellageraldinc Adryamarthanino on 31/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class AkademikTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: CategoryUiLabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var txtDescription: UITextView!
    
    let labelCategoryCornerRadius = 2.0
    let cellBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    let cardViewBackgroundColor = UIColor.white
    let cardViewCornerRadius = 3.0
    let cardViewShadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    let cardViewShadowOffset = CGSize(width: 0, height: 0)
    let cardViewShadowOpacity = 0.8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblCategory.layer.masksToBounds = true
        lblCategory.layer.cornerRadius = CGFloat(labelCategoryCornerRadius)
        txtDescription.textContainer.maximumNumberOfLines = 3
        txtDescription.textContainerInset = .zero
        txtDescription.textContainer.lineFragmentPadding = 0
//        contentView.backgroundColor = cellBackgroundColor
//        cardView.backgroundColor = cardViewBackgroundColor
        cardView.layer.cornerRadius = CGFloat(cardViewCornerRadius)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = cardViewShadowColor
        cardView.layer.shadowOffset = cardViewShadowOffset
        cardView.layer.shadowOpacity = Float(cardViewShadowOpacity)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
