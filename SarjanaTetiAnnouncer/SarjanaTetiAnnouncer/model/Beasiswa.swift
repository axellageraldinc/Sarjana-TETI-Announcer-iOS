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
    let deadline: String
    let detailUrl: String
    let date: String
    
    init(id: String, title: String, deadline: String, detailUrl: String, date: String) {
        self.id=id
        self.title=title
        self.deadline=deadline
        self.detailUrl=detailUrl
        self.date=date
    }
}
