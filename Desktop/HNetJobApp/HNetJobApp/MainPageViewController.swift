//
//  MainPageViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 8/23/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainPageViewController: UIViewController {
    
    
    //the job list api
    //filters by user profile
    let API_URL = "https://jobapp.h-net.org/1.0/Job"
    
    //the user data api
    let USR_URL = "https://jobapp.h-net.org/1.0/User"
    
    //array of the job titles
    var jobTitles: [String] = []
    //array of job text
    var jobDescriptions :[String] = []
    //array of job locations
    var locations: [String] = []
    //array of job posted dates
    var datePosted: [String] = []
    //array of job institutions
    var institutionArray: [String] = []
    //array of user saved jobs
    var userSavedJobs: [Int] = []
    //array of user hidden jobs
    var userHiddenJobs: [Int] = []
    //array for state_id
    var stateArray: [Int] = []
    //array for country_id
    var countryArray: [Int] = []
    //array for institution types
    var institutionType: [String] = []
    
    //going to need jobID array to pass the correct job to the saved and hidden jobs section
    var jobIDs: [Int] = []
    
    var jobTitleLabel = UILabel()
    var descriptionLabel = UILabel()
    var dateLabel = UILabel()
    var institution = UILabel()
    
    var i = 0
    
    var titleCons: [NSLayoutConstraint] = []
    
    var institutionCons: [NSLayoutConstraint] = []
    
    var dateCons: [NSLayoutConstraint] = []
    
    var descCons: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get data from server
        getData(url: API_URL)
        
        //Tinder Style Swipe card
        let label = UIView(frame: CGRect(x: self.view.bounds.width/2-150, y: self.view.bounds.height/2-130, width: 300, height: 300))
        
        view.addSubview(label)
        
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = true;
        
        label.backgroundColor = UIColor.lightGray
        
        //jobTitleLabel = UILabel(frame: CGRect(x: label.bounds.width/10, y: label.bounds.height/10, width: 200, height: 20))
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        jobTitleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 14.0)
        jobTitleLabel.text = "Loading..."
        jobTitleLabel.numberOfLines = 0
        jobTitleLabel.lineBreakMode = .byWordWrapping
        jobTitleLabel.sizeToFit()
        label.addSubview(jobTitleLabel)
        
        let jobTitleTop = jobTitleLabel.topAnchor.constraint(equalTo: label.topAnchor, constant: 15)
        let jobTitleBottom = jobTitleLabel.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 40)
        let jobTitleleft = jobTitleLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 10)
        let jobTitleright = jobTitleLabel.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -10)
        
        titleCons = [jobTitleTop, jobTitleBottom, jobTitleleft, jobTitleright]
        
        NSLayoutConstraint.activate(titleCons)
        
        institution.translatesAutoresizingMaskIntoConstraints = false
        institution.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        institution.text = "Swipe left or right to cycle through available jobs. Select the save icon to add to favorites or the hide icon to hide the job.  You may access either listing though the menu."
        institution.numberOfLines = 0
        institution.lineBreakMode = .byWordWrapping
        institution.sizeToFit()
        label.addSubview(institution)
        
        let insTop = institution.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 15)
        //let insBottom = institution.bottomAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 40)
        let insleft = institution.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 10)
        let insright = institution.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -10)
        
        institutionCons = [insTop, insleft, insright]
        
        NSLayoutConstraint.activate(institutionCons)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = ""
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont(name:"HelveticaNeue", size: 10.0)
        label.addSubview(dateLabel)
        
        let dateTop = dateLabel.topAnchor.constraint(equalTo: institution.bottomAnchor, constant: 15)
        let dateBottom = dateLabel.bottomAnchor.constraint(equalTo: institution.bottomAnchor, constant: 40)
        let dateleft = dateLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 10)
        let dateright = dateLabel.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 10)
        
        dateCons = [dateTop, dateBottom, dateleft, dateright]
        
        NSLayoutConstraint.activate(dateCons)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name:"HelveticaNeue", size: 12.0)
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.sizeToFit()
        label.addSubview(descriptionLabel)
        
        
        let descTop = descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15)
        //let descBottom = descriptionLabel.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 0)
        let descleft = descriptionLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: 10)
        let descright = descriptionLabel.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -10)
        
        descCons = [descTop, descleft, descright]
        
        NSLayoutConstraint.activate(descCons)
       
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        label.isUserInteractionEnabled = true
        
        label.addGestureRecognizer(gesture)
        
        
        
    }
    
    func getData(url: String)
    {
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(url, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                self.populateArrays(json : apiJSON)
            }
            else
            {
                print("Error getting JSON in the getData function")
            }
        }
        
    }

    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer)
    {
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        
        label.center = CGPoint(x: self.view.bounds.width/2+translation.x, y: self.view.bounds.height/2+translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width/2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/200)
        
        let scale = min(abs(100/xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended
        {
            if label.center.x < 100
            {
                i = i - 1
                
                if(i<0)
                {
                    i = jobIDs.count-1
                }
                
                /*
                print("Size of job titles array: ")
                print(jobTitles.count)
                print("Size of job ids array: ")
                print(jobIDs.count)
                print("current i: ")
                print(i)
                */
                
                jobTitleLabel.text = jobTitles[i]
                jobTitleLabel.numberOfLines = 0
                jobTitleLabel.lineBreakMode = .byWordWrapping
                jobTitleLabel.sizeToFit()

                descriptionLabel.text = jobDescriptions[i]
                descriptionLabel.numberOfLines = 0
                descriptionLabel.lineBreakMode = .byWordWrapping
                descriptionLabel.sizeToFit()
                
                dateLabel.text = datePosted[i]
                
                institution.text = institutionArray[i]
                institution.numberOfLines = 0
                institution.lineBreakMode = .byWordWrapping
                institution.sizeToFit()
                
            }
            else if label.center.x>self.view.bounds.width - 100
            {
                
                i = i + 1
                
                if(i>=jobIDs.count)
                {
                    i = 0
                }
                
                jobTitleLabel.text = jobTitles[i]
                jobTitleLabel.numberOfLines = 0
                jobTitleLabel.lineBreakMode = .byWordWrapping
                jobTitleLabel.sizeToFit()
                
                descriptionLabel.text = jobDescriptions[i]
                descriptionLabel.numberOfLines = 0
                descriptionLabel.lineBreakMode = .byWordWrapping
                descriptionLabel.sizeToFit()
                
                dateLabel.text = datePosted[i]
                
                institution.text = institutionArray[i]
                institution.numberOfLines = 0
                institution.lineBreakMode = .byWordWrapping
                institution.sizeToFit()
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
            
        }
        
        
    }
    
    
    func populateArrays(json : JSON)
    {
        
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            // Check if the JSON is an array otherwise nil
            if let jArray = json.array {
                /*
                 array of objects containing:
                 job_id              integer
                 institution_name    string (hidden if empty)
                 institution_type    string (backing data is an enum)
                 'College / University','Government','Nonprofit','Other',
                 'Preparatory School','Two-Year College'
                 department          string (hidden if empty)
                 country_id          integer
                 state_id            integer
                 description         string (post title)
                 text                string (full posting text, backed by a blob)
                 contact             string (backed by a blob)
                 website             string (url)
                 logo                string (base64 encoded image file)
                 date_posting        integer (unix time_t)
                 date_closing        integer (unix time_t)
                 featured            boolean (job gets more prominent display)*/
                
                //load the entire arrays
                let size = jArray.count
                
                for i in 0..<size
                {
                    self.jobTitles.append(jArray[i]["description"].stringValue)
                    self.jobDescriptions.append(jArray[i]["text"].stringValue)
                    
                    //the dates require some extra work
                    let date = Date(timeIntervalSince1970: jArray[i]["date_posting"].double!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                    dateFormatter.locale = NSLocale.current
                    dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
                    let strDate = dateFormatter.string(from: date)
                    self.datePosted.append(strDate)
                    
                    self.institutionArray.append(jArray[i]["institution_name"].stringValue)
                    self.jobIDs.append(Int(jArray[i]["job_id"].intValue))
                    
                    self.countryArray.append(jArray[i]["country_id"].intValue)
                    self.institutionArray.append(jArray[i]["institution_type"].stringValue)
                    self.stateArray.append(jArray[i]["state_id"].intValue)
                    //print("i is now: \(i), and the value in the institution array is: ")
                    //print(jArray[i]["institution_type"].stringValue)
                }
                /*
                print("Country Array contents: ")
                print(countryArray.description)
                print("State Array contents: ")
                print(stateArray.description)
                print("Institution array contents: ")
                print(institutionArray.description)
                */
                
                self.getSavedAndHidden()
                
                
            }
        }
        
    }
    
    func getSavedAndHidden()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(USR_URL, method: .get).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.removeSavedAndHiddenFromQueue(json: apiJSON)==1)
                    {
                        //we know that we have removed the duplicate job data now.
                        //lets give some initial values
                        
                        self.jobTitleLabel.text = self.jobTitles[0]
                        self.jobTitleLabel.numberOfLines = 0
                        self.jobTitleLabel.lineBreakMode = .byWordWrapping
                        self.jobTitleLabel.sizeToFit()
                        
                        self.descriptionLabel.text = self.jobDescriptions[0]
                        self.descriptionLabel.numberOfLines = 0
                        self.descriptionLabel.lineBreakMode = .byWordWrapping
                        self.descriptionLabel.sizeToFit()
                        
                        self.dateLabel.text = self.datePosted[0]
                        
                        self.institution.text = self.institutionArray[0]
                        self.institution.numberOfLines = 0
                        self.institution.lineBreakMode = .byWordWrapping
                        self.institution.sizeToFit()
                        
                        
                    }
                    else
                    {
                        print("error has occured getting the data")
                    }
                }
        }
        
        
    }
    
    func removeSavedAndHiddenFromQueue(json: JSON) -> Int
    {
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let hidden = json["hiddenjobs"]
            
            let size = hidden.count
           
            for i in 0..<size
            {
                self.userHiddenJobs.append(hidden[i].intValue)
            }
            
            //now that we have their hidden job ids, lets delete them from our list
            for i in 0..<userHiddenJobs.count
            {
                if(jobIDs.contains(userHiddenJobs[i]))
                {
                    let index = jobIDs.index(of: userHiddenJobs[i])
                    self.jobIDs.remove(at: index!)
                    self.jobTitles.remove(at: index!)
                    self.jobDescriptions.remove(at: index!)
                    self.datePosted.remove(at: index!)
                    self.institutionArray.remove(at: index!)
                    
                }
            }
            
            let saved = json["savedjobs"]
            
            let savedSize = saved.count
            
            for j in 0..<savedSize
            {
                self.userSavedJobs.append(saved[j].intValue)
            }
            
            //now that we have their hidden job ids, lets delete them from our list
            for j in 0..<userSavedJobs.count
            {
                if(jobIDs.contains(userSavedJobs[j]))
                {
                    let index2 = jobIDs.index(of: userSavedJobs[j])
                    self.jobIDs.remove(at: index2!)
                    self.jobTitles.remove(at: index2!)
                    self.jobDescriptions.remove(at: index2!)
                    self.datePosted.remove(at: index2!)
                    self.institutionArray.remove(at: index2!)
                    
                }
            }
            
            
            return 1
        }
        
        return 0
        
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any)
    {
        var SHARE_URL = "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fjobapp.h-net.org%2FDetailedJob.html%3Fjobid%3D"
        
        SHARE_URL = "\(SHARE_URL)\(jobIDs[i])&amp;src=sdkpreparse"
        
        print(SHARE_URL)
        
        if let url = NSURL(string: SHARE_URL)
        {
            UIApplication.shared.openURL(url as URL)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func menuButtonPressed(_ sender: Any)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    @IBAction func addToFavorites(_ sender: Any)
    {
        //reset array so we dont get duplicates
        userSavedJobs = []
        
        getUserData()
        
    }
    
    @IBAction func addToHidden(_ sender: Any)
    {
        //reset array so we dont get duplicates
        userHiddenJobs = []
        
        getHiddenUserData()
        
    }
    
    func getHiddenUserData()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(USR_URL, method: .get).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Successful network call getting the user field data")
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.getHiddenFields(json: apiJSON)==1)
                    {
                        //print("The saved job id numbers are: ")
                        //print(self.userHiddenJobs.description)
                        
                        self.addHiddenJobByID()
                        
                    }
                    else
                    {
                        print("error has occured getting the data")
                    }
                }
        }
        
    }
    
    func getHiddenFields(json: JSON) -> Int
    {
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let hidden = json["hiddenjobs"]
            
            let size = hidden.count
            
            for i in 0..<size
            {
                self.userHiddenJobs.append(hidden[i].intValue)
            }
            
            return 1
        }
        
        return 0
    }


    
    
    func getUserData()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(USR_URL, method: .get).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Successful network call getting the user field data")
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.getFields(json: apiJSON)==1)
                    {
                        
                        //print("The saved job id numbers are: ")
                        //print(self.userSavedJobs.description)
                        
                        self.addJobByID()
                        
                    }
                    else
                    {
                        print("error has occured getting the data")
                    }
                }
        }
        
    }
    
    func getFields(json: JSON) -> Int
    {
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let saved = json["savedjobs"]
            
            
            let size = saved.count
            
            for i in 0..<size
            {
                self.userSavedJobs.append(saved[i].intValue)
            }
            
            return 1
        }
        
        return 0
    }
    
    func addHiddenJobByID()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        var updatedHiddenJobs = userHiddenJobs
        updatedHiddenJobs.append(jobIDs[i])
        
        let parameters: Parameters = [
            "hiddenjobs": updatedHiddenJobs
        ]
        
        //function to update user categories
        //will require a patch request using alamofire
        Alamofire.request(USR_URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    
                    self.displayAlertMessage(userMessage: "Successfully added job to hidden jobs list!")
                    
                    
                }
                else
                {
                    print("error in changeCategories method")
                }
        }
        
    }

    
    func addJobByID()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        var updatedSavedJobs = userSavedJobs
        updatedSavedJobs.append(jobIDs[i])
        
        let parameters: Parameters = [
            "savedjobs": updatedSavedJobs
        ]
        
        //function to update user categories
        //will require a patch request using alamofire
        Alamofire.request(USR_URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    
                    self.displayAlertMessage(userMessage: "Successfully added job to saved jobs list!")
                    
                    
                }
                else
                {
                    print("error in addJobByID method")
                }
            }
        
    }
    
    func displayAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Notification", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func goToExpand(_ sender: Any)
    {
        let data = jobIDs[i]
        
        
        let expandedJobsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpandedJobCardViewController") as! ExpandedJobCardViewController
        
        expandedJobsViewController.passedID = data
        
        let expandedJobsNav = UINavigationController(rootViewController: expandedJobsViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if((appDelegate.drawerContainer) == nil){
            print("drawer container is null")
            
        }
        
        appDelegate.drawerContainer!.centerViewController = expandedJobsNav
        
    }
    
    
}
