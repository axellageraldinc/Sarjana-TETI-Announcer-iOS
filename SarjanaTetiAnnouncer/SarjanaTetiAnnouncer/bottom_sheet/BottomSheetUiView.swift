//
//  BottomSheetUiView.swift
//  SarjanaTetiAnnouncer
//
//  Created by Axellageraldinc Adryamarthanino on 01/06/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit

class BottomSheetUiView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDownloadExternalFile: UIButton!
    @IBOutlet weak var lblDescription: UITextView!
    
    var downloadUrl: String?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let nib = UINib(nibName: "BottomSheetUiView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }

    @IBAction func btnDownloadExternalFileClicked(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: downloadUrl!)!)
    }
}
