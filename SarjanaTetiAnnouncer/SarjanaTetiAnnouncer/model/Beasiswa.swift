//
//  Beasiswa.swift
//  SarjanaTetiAnnouncer
//
//  Created by Axellageraldinc Adryamarthanino on 31/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import Foundation

class Beasiswa {
    let id: String
    let title: String
    let category: String
    let description: String?
    let date: String
    let downloadUrl: String?
    
    init(id: String, title: String, category: String, description: String, date: String, downloadUrl: String) {
        self.id=id
        self.title=title
        self.category=category
        self.description=description
        self.date=date
        self.downloadUrl=downloadUrl
    }
}
