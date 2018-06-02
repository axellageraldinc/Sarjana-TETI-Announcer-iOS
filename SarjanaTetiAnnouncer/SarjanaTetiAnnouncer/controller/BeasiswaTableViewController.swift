//
//  BeasiswaTableViewController.swift
//  SarjanaTetiAnnouncer
//
//  Created by Axellageraldinc Adryamarthanino on 31/05/18.
//  Copyright © 2018 Axellageraldinc Adryamarthanino. All rights reserved.
//

import UIKit
import SwiftSoup
import SafariServices

class BeasiswaTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    var beasiswaList: [Beasiswa]! = nil
    var beasiswa: Beasiswa! = nil
    let baseUrl = "http://sarjana.jteti.ugm.ac.id"
    let beasiswaUrl = URL(string: "http://sarjana.jteti.ugm.ac.id/kemahasiswaan/peluang-mahasiswa/beasiswa")
    var sarjanaJtetiBeasiswaInformationTable:Elements! = nil
    
    let nib = UINib.init(nibName: "BeasiswaTableViewCell", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshSarjanaJtetiBeasiswa), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.activityIndicatorView = activityIndicatorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.beasiswaList == nil) {
//            UIApplication.shared.beginIgnoringInteractionEvents()
            activityIndicatorView.startAnimating()
            DispatchQueue.global(qos: .userInteractive).async {
                // Do some background work
                self.getBeasiswaInformationFromSarjanaJtetiWebsite()
                DispatchQueue.main.async {
                    // Update the UI to indicate the work has been completed
                    self.tableView.register(self.nib, forCellReuseIdentifier: "BeasiswaTableViewCell")
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
//                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    @objc func refreshSarjanaJtetiBeasiswa() {
        DispatchQueue.global(qos: .userInteractive).async {
            // Do some background work
            self.getBeasiswaInformationFromSarjanaJtetiWebsite()
            DispatchQueue.main.async {
                // Update the UI to indicate the work has been completed
                self.tableView.register(self.nib, forCellReuseIdentifier: "BeasiswaTableViewCell")
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    // MARK: - Website Scrapping
    
    func getBeasiswaInformationFromSarjanaJtetiWebsite() {
        do {
            let sarjanaJtetiBeasiswaHtmlFromUrl = try String.init(contentsOf: beasiswaUrl!)
            let sarjanaJtetiBeasiswaHtmlDocument = try SwiftSoup.parse(sarjanaJtetiBeasiswaHtmlFromUrl)
            
            self.sarjanaJtetiBeasiswaInformationTable = try! sarjanaJtetiBeasiswaHtmlDocument.select("table.table-pad > tbody > tr")
            let sarjanaJtetiBeasiswaInformationTableContents = try! sarjanaJtetiBeasiswaInformationTable.select("td:eq(2)")
            self.beasiswaList = getSarjanaJtetiBeasiswaTableContent(sarjanaJtetiAkademikInformationTableContents: sarjanaJtetiBeasiswaInformationTableContents)
            
        } catch let error {
            // an error occurred
            print("Error: \(error)")
        }
    }
    
    func getSarjanaJtetiBeasiswaTableContent(sarjanaJtetiAkademikInformationTableContents: Elements) -> [Beasiswa] {
        var informationList = [Beasiswa]()
        for index in 0...sarjanaJtetiAkademikInformationTableContents.size()-1 {
            let content = sarjanaJtetiAkademikInformationTableContents.get(index)
            let id = UUID().uuidString
            let title = getTitle(content: content)
            let date = getDate(content: content)
            let detailUrl = getBeasiswaDetailUrl(index: index)
            let deadline = getDeadline(beasiswaDetailUrl: URL(string: detailUrl)!)
            print("ID : " + id)
            print("TITLE : " + title)
            print("Date : " + date)
            print("Detail URL : " + detailUrl)
            print("Deadline : " + deadline)
            let information = Beasiswa(id: id, title: title, deadline: deadline, detailUrl: detailUrl, date: date)
            informationList.append(information)
        }
        return informationList
    }
    
    func getTitle(content: Element) -> String {
        var title = ""
        let dateAndTitle = try! content.select("td").text().split(separator: " ")
        for x in 2...dateAndTitle.count-1 {
            title+=dateAndTitle[x] + " "
        }
        return title
    }
    
    func getDate(content: Element) -> String {
        var date = ""
        let dateAndTitle = try! content.select("td").text().split(separator: " ")
        date = String(dateAndTitle[0])
        return date
    }
    
    func getBeasiswaDetailUrl(index: Int) -> String {
        var detailUrl = try! self.sarjanaJtetiBeasiswaInformationTable.get(index).attr("data-href")
        detailUrl = baseUrl+detailUrl
        return detailUrl
    }
    
    func getDeadline(beasiswaDetailUrl: URL) -> String {
        var deadline=""
        do {
            let sarjanaJtetiBeasiswaDetailHtmlFromUrl = try String.init(contentsOf: beasiswaDetailUrl)
            let sarjanaJtetiBeasiswaDetailHtmlDocument = try SwiftSoup.parse(sarjanaJtetiBeasiswaDetailHtmlFromUrl)
            
            let sarjanaJtetiBeasiswaDetailDeadline = try! sarjanaJtetiBeasiswaDetailHtmlDocument.select("p:contains(Deadline)")
            deadline = try! sarjanaJtetiBeasiswaDetailDeadline.text()
        } catch let error {
            // an error occurred
            print("Error: \(error)")
        }
        return deadline
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.beasiswaList == nil) ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beasiswaList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeasiswaTableViewCell", for: indexPath) as! BeasiswaTableViewCell
        let beasiswa = self.beasiswaList[indexPath.row]
        cell.lblId.text = beasiswa.id
        cell.lblTitle.text = beasiswa.title
        cell.lblDate.text = beasiswa.date
        cell.lblDeadline.text = beasiswa.deadline
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let beasiswa = self.beasiswaList[indexPath.row]
        let url = URL(string: beasiswa.detailUrl)!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
