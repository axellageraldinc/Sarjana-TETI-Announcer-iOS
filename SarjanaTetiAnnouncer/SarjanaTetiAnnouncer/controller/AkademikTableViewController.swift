//
//  ViewController.swift
//  SarjanaTetiAnnouncer
//
//  Created by Axellageraldinc Adryamarthanino on 31/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit
import SwiftSoup
import Bottomsheet

class AkademikTableViewController: UITableViewController {
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    var akademikList: [Akademik]! = nil
    var akademik: Akademik! = nil
    let url = URL(string: "http://sarjana.jteti.ugm.ac.id/akademik")

    override func viewDidLoad() {
        super.viewDidLoad()
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.activityIndicatorView = activityIndicatorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.akademikList == nil) {
            UIApplication.shared.beginIgnoringInteractionEvents()
            activityIndicatorView.startAnimating()
            DispatchQueue.global(qos: .background).async {
                // Do some background work
                self.getAkademikInformationFromSarjanaJtetiWebsite()
                DispatchQueue.main.async {
                    // Update the UI to indicate the work has been completed
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    // MARK: - Website Scrapping

    func getAkademikInformationFromSarjanaJtetiWebsite() {
        do {
            let sarjanaJtetiAkademikHtmlFromUrl = try String.init(contentsOf: url!)
            let sarjanaJtetiAkademikHtmlDocument = try SwiftSoup.parse(sarjanaJtetiAkademikHtmlFromUrl)
            
            let sarjanaJtetiAkademikInformationTable = try! sarjanaJtetiAkademikHtmlDocument.select("table.table-pad > tbody > tr")
            let sarjanaJtetiAkademikInformationTableContents = try! sarjanaJtetiAkademikInformationTable.select("td:eq(2)")
            self.akademikList = getSarjanaJtetiAkademikTableContent(sarjanaJtetiAkademikInformationTableContents: sarjanaJtetiAkademikInformationTableContents)
            
        } catch let error {
            // an error occurred
            print("Error: \(error)")
        }
    }
    
    func getSarjanaJtetiAkademikTableContent(sarjanaJtetiAkademikInformationTableContents: Elements) -> [Akademik] {
        var informationList = [Akademik]()
        for content in sarjanaJtetiAkademikInformationTableContents {
            let id = getNewsId(content: content)
            let title = getNewsTitle(content: content)
            let category = getNewsCategory(content: content)
            let description = getNewsDescription(content: content)
            let date = getNewsDate(content: content)
            let additionalMaterialDownloadLink = getNewsUrl(content: content)
            let information = Akademik(id: id, title: title, category: category, description: description, date: date, downloadUrl: additionalMaterialDownloadLink)
            informationList.append(information)
        }
        return informationList
    }
    
    func getNewsId(content: Element) -> String {
        return (content.parents().first()?.id())!
    }
    
    func getNewsTitle(content: Element) -> String {
        return try! content.select("b").text()
    }
    
    func getNewsCategory(content: Element) -> String {
        return try! content.select("span.label").text()
    }
    
    func getNewsDescription(content: Element) -> String {
        let bodyText = try! content.text().split(separator: " ")
        let title = getNewsTitle(content: content)
        let titleSize = title.split(separator: " ").count
        var x: Int = 4 + titleSize
        var description = ""
        while (x < bodyText.count) {
            description += bodyText[x] + " "
            x+=1
        }
        let linkDownload = getNewsUrl(content: content)
        if(!linkDownload.isEmpty) {
            description = String(description.dropLast(9))
        }
        return description
    }
    
    func getNewsDate(content: Element) -> String {
        var y = 1
        var date = ""
        let bodyText = try! content.text().split(separator: " ")
        while (y < 4) {
            date += bodyText[y] + " "
            y+=1
        }
        return date
    }
    
    func getNewsUrl(content: Element) -> String {
        let linkDownload = try! content.select("a.btn").attr("href")
        if (!linkDownload.isEmpty) {
            return "http://sarjana.jteti.ugm.ac.id" + linkDownload
        } else {
            return ""
        }
    }
    
    // MARK: - Utilities
    
    @objc func shareAkademikInformation() {
        
        var message = "Pengumuman : " + self.akademik.title + "\nDeskripsi : " + self.akademik.description!
        if(self.akademik.downloadUrl==""){
        } else{
            message+="\nLink download : " + self.akademik.downloadUrl!
        }
        let activityViewController = UIActivityViewController(activityItems: [message as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.akademikList == nil) ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.akademikList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AkademikTableViewCell", for: indexPath) as! AkademikTableViewCell
        let akademik = self.akademikList[indexPath.row]
        cell.lblId!.text = akademik.id
        cell.lblCategory!.text = akademik.category
        if(akademik.category == "Akademik"){
            let color = hexStringToUIColor(hex: "#00BBE8")
            cell.lblCategory!.backgroundColor = color
        } else if(akademik.category == "Perkuliahan"){
            let color = hexStringToUIColor(hex: "#F5BE02")
            cell.lblCategory!.backgroundColor = color
        }
        cell.lblDate!.text = akademik.date
        cell.lblTitle!.text = akademik.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = BottomsheetController()
        let contentView = BottomSheetUiView()
        let akademik = self.akademikList[indexPath.row]
        self.akademik = akademik
        contentView.lblTitle.text = akademik.title
        contentView.lblDescription.text = akademik.description
        if(akademik.downloadUrl==""){
            contentView.btnDownloadExternalFile.isHidden = true
        } else{
            contentView.downloadUrl = akademik.downloadUrl
        }
        controller.addNavigationbar { navigationBar in
            let item = UINavigationItem(title: "Detailed Information")
            let leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(self.shareAkademikInformation))
            item.leftBarButtonItem = leftButton
            navigationBar.items = [item]
        }
        controller.viewActionType = .tappedDismiss
        controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.addContentsView(contentView)
        self.present(controller, animated: true, completion: nil)
    }

}
