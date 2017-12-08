//
//  ExpandedJobCardViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 10/15/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import EventKit

class ExpandedJobCardViewController: UIViewController {

    @IBOutlet weak var scrollableCard: UIScrollView!
    
    
    
    var API_URL = "https://jobapp.h-net.org/1.0/Job?jobid="
    
    var passedID = 0
    
    var jobTitleLabel = UILabel()
    var dateLabel = UILabel()
    var descriptionLabel = UILabel()
    var websiteLabel = UILabel()
    var calendarButton = UIButton()
    
    var titleCons: [NSLayoutConstraint] = []
    var dateCons: [NSLayoutConstraint] = []
    var websiteCons: [NSLayoutConstraint] = []
    var descCons: [NSLayoutConstraint] = []
    
    var scrollCons: [NSLayoutConstraint] = []
    
    var btnCons: [NSLayoutConstraint] = []
    
    var end_Date: Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Print passed id")
        print(passedID)
        
        API_URL = "\(API_URL)\(passedID)"
        
        scrollableCard.contentSize.height = 2000
        scrollableCard.isDirectionalLockEnabled = true
        //scrollableCard.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        /*
        scrollableCard.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollTop = scrollableCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        let scrollBottom = scrollableCard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        let scrollleft = scrollableCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        let scrollright = scrollableCard.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        
        scrollCons = [scrollTop, scrollBottom, scrollleft, scrollright]
        
        NSLayoutConstraint.activate(scrollCons)
        */
        
        //jobTitleLabel = UILabel(frame: CGRect(x: scrollableCard.bounds.width/10, y: (scrollableCard.bounds.height/10)-80, width: 200, height: 20))
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        jobTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        jobTitleLabel.text = "Loading..."
        jobTitleLabel.numberOfLines = 0
        jobTitleLabel.lineBreakMode = .byWordWrapping
        jobTitleLabel.sizeToFit()
        scrollableCard.addSubview(jobTitleLabel)
        
        let jobTitleTop = jobTitleLabel.topAnchor.constraint(equalTo: scrollableCard.topAnchor, constant: 15)
        //let jobTitleBottom = jobTitleLabel.bottomAnchor.constraint(equalTo: scrollableCard.topAnchor, constant: 40)
        let jobTitleleft = jobTitleLabel.leadingAnchor.constraint(equalTo: scrollableCard.leadingAnchor, constant: 10)
        let jobTitleright = jobTitleLabel.rightAnchor.constraint(equalTo: scrollableCard.rightAnchor, constant: -10)
        
        titleCons = [jobTitleTop, jobTitleleft, jobTitleright]
        
        NSLayoutConstraint.activate(titleCons)
        
        //dateLabel = UILabel(frame: CGRect(x: scrollableCard.bounds.width/10, y: scrollableCard.bounds.height/20 + 50, width: 200, height: 20))
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = ""
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont(name:"HelveticaNeue", size: 10.0)
        scrollableCard.addSubview(dateLabel)
        
        let dateTop = dateLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 15)
        let dateBottom = dateLabel.bottomAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 40)
        let dateleft = dateLabel.leadingAnchor.constraint(equalTo: scrollableCard.leadingAnchor, constant: 10)
        let dateright = dateLabel.rightAnchor.constraint(equalTo: scrollableCard.rightAnchor, constant: -10)
        
        dateCons = [dateTop, dateBottom, dateleft, dateright]
        
        NSLayoutConstraint.activate(dateCons)
        
        //websiteLabel = UILabel(frame: CGRect(x: scrollableCard.bounds.width/10, y: scrollableCard.bounds.height/20 + 500, width: 200, height: 20))
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        websiteLabel.text = ""
        scrollableCard.addSubview(websiteLabel)
        
        let siteTop = websiteLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15)
        let siteBottom = websiteLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 40)
        let siteleft = websiteLabel.leadingAnchor.constraint(equalTo: scrollableCard.leadingAnchor, constant: 10)
        let siteright = websiteLabel.rightAnchor.constraint(equalTo: scrollableCard.rightAnchor, constant: -10)
        
        websiteCons = [siteTop, siteBottom, siteleft, siteright]
        
        NSLayoutConstraint.activate(websiteCons)
        
        //descriptionLabel = UILabel(frame: CGRect(x: scrollableCard.bounds.width/10, y: scrollableCard.bounds.height/20 + 100, width: 275, height: 20))
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        descriptionLabel.text = "please wait"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.sizeToFit()
        scrollableCard.addSubview(descriptionLabel)
        
        
        let descTop = descriptionLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 15)
        //let descBottom = descriptionLabel.bottomAnchor.constraint(equalTo: scrollableCard.bottomAnchor, constant: 0)
        let descleft = descriptionLabel.leadingAnchor.constraint(equalTo: scrollableCard.leadingAnchor, constant: 10)
        let descright = descriptionLabel.rightAnchor.constraint(equalTo: scrollableCard.rightAnchor, constant: -10)
        
        descCons = [descTop, descleft, descright]
        
        NSLayoutConstraint.activate(descCons)
        
        //let calendarButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        //calendarButton.backgroundColor = .green
        calendarButton.setTitle("", for: .normal)
        calendarButton.setTitleColor(.black, for: .normal)
        calendarButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        scrollableCard.addSubview(calendarButton)
        
        let btnTop = calendarButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15)
        //let btnBottom = calendarButton.bottomAnchor.constraint(equalTo: scrollableCard.bottomAnchor, constant: -10)
        let btnleft = calendarButton.leadingAnchor.constraint(equalTo: scrollableCard.leadingAnchor, constant: 50)
        let btnright = calendarButton.rightAnchor.constraint(equalTo: scrollableCard.rightAnchor, constant: -50)
        
        btnCons = [btnTop, btnleft, btnright]
        
        NSLayoutConstraint.activate(btnCons)
        
        
        getData(url: API_URL)
        
    }
    
    func displayAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Notification", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }

    
    func buttonAction(sender: UIButton!)
    {
        print("calendarButton tapped")
        
        // Create an Event Store instance
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) {(granted, error) in
        
            if(granted && (error==nil))
            {
                print("granted \(granted)")
                print("error \(error)")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.jobTitleLabel.text!
                event.startDate = self.end_Date
                event.endDate = self.end_Date.addingTimeInterval(60*60*12)
                event.notes = ""
                event.calendar = eventStore.defaultCalendarForNewEvents
                do
                {
                    try eventStore.save(event, span: .thisEvent)
                }
                catch let error as NSError
                {
                    print("error: \(error)")
                }
                print("Save Event")
                self.displayAlertMessage(userMessage: "Saved to Calendar")
            }
            else
            {
                print("error: \(error)")
            }
        
        
        }
        
    }
    
    func getData(url: String)
    {
        
        print("In the get data function")
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(url, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the new data")
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                self.populateArrays(json : apiJSON)
            }
            else
            {
                print("Error getting JSON in the getData function")
            }
        }
        
    }
    
    func populateArrays(json : JSON)
    {
        print("populateArrays got called")
        
        let body = json["body"].stringValue
     
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            
            let json = JSON(data: dataFromString)
            
            
            if let jsonArray = json.array
            {
                
                for i in 0..<jsonArray.count
                {
                    let desc = jsonArray[i]["description"].stringValue
                    print(desc)
                    jobTitleLabel.text = desc
                    jobTitleLabel.numberOfLines = 0
                    jobTitleLabel.lineBreakMode = .byWordWrapping
                    jobTitleLabel.sizeToFit()

                    
                    let text = jsonArray[i]["text"].stringValue
                    print(text)
                    descriptionLabel.text = text
                    descriptionLabel.numberOfLines = 0
                    descriptionLabel.lineBreakMode = .byWordWrapping
                    descriptionLabel.sizeToFit()
                    
                    let website = jsonArray[i]["website"].stringValue
                    print(text)
                    websiteLabel.text = website
                    websiteLabel.numberOfLines = 0
                    websiteLabel.lineBreakMode = .byWordWrapping
                    websiteLabel.sizeToFit()
                    
                    //the dates require some extra work
                    let date = Date(timeIntervalSince1970: jsonArray[i]["date_posting"].double!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    print(strDate)
                    dateLabel.text = strDate
                    
                    calendarButton.setTitle("Add to Calendar", for: .normal)
                    
                    
                    //the dates require some extra work
                    let date2 = Date(timeIntervalSince1970: jsonArray[i]["date_closing"].double!)
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                    dateFormatter2.locale = NSLocale.current
                    dateFormatter2.dateFormat = "MM-dd-yyyy" //Specify your format that you want
                    let strDate2 = dateFormatter2.string(from: date2)
                    print("End date for posting is: ")
                    print(strDate2)
                    
                    end_Date = date2

                }
                
            }
        }
        
    }
    
    @IBAction func menuButtonPressed(_ sender: Any)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
