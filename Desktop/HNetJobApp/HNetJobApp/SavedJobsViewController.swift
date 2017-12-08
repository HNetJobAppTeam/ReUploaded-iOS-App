//
//  SavedJobsViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 9/7/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SavedJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //this is the array that will populate the tableview object
    var menuItems:[String] = []
    
    //this is the job title array comprised of all the job titles
    var jobTitles: [String] = []
    
    //this is useless
    var jobDescriptions: [String] = []
    
    //this is the array of all of the job ids.
    var jobIDs: [Int] = []
    
    //this is the array of the jobs that the user has saved to their account
    var userSaved: [Int] = []
    
    
    
    
    @IBOutlet weak var tblVeew: UITableView!
    
    //this is the api for getting all of the jobs
    let API_URL = "https://jobapp.h-net.org/1.0/Job"
    
    //this is the api for the user data
    let USR_URL = "https://jobapp.h-net.org/1.0/User"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getData(url: API_URL)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        //var lblCons: [NSLayoutConstraint] = []
        
        //myCell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        myCell.textLabel?.text = menuItems[(indexPath as NSIndexPath).row]
        myCell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 10.0)
        
        var btnCons: [NSLayoutConstraint] = []
        
        let btn = UIButton()
        var image = UIImage()
        image = #imageLiteral(resourceName: "cancel-512 (1)")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .lightGray
        //btn.setTitle("", for: .normal)
        btn.setImage(image, for: .normal)
        //btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        myCell.addSubview(btn)
        
        btn.layer.cornerRadius = 15
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.0
        
        let btnTop = btn.topAnchor.constraint(equalTo: myCell.topAnchor, constant: 5)
        let btnBottom = btn.bottomAnchor.constraint(equalTo: myCell.bottomAnchor, constant: -5)
        let btnleft = btn.leadingAnchor.constraint(equalTo: myCell.leadingAnchor, constant: 250)
        let btnright = btn.rightAnchor.constraint(equalTo: myCell.rightAnchor, constant: -5)
        
        btnCons = [btnTop, btnleft, btnBottom, btnright]
        
        NSLayoutConstraint.activate(btnCons)
        
        //let lblleft = myCell.textLabel?.leadingAnchor.constraint(equalTo: myCell.leadingAnchor, constant: 5)
        //let lblright = myCell.textLabel?.rightAnchor.constraint(equalTo: btn.leadingAnchor, constant: -5)
        
        //lblCons = [lblright!]
        
        //NSLayoutConstraint.activate(lblCons)
        
        return myCell
    }
    
    func buttonAction(sender: UIButton!)
    {
        let position: CGPoint = sender.convert(CGPoint.zero, to: self.tblVeew)
        let indexPath = self.tblVeew.indexPathForRow(at: position)
        let cell: UITableViewCell = tblVeew.cellForRow(at: indexPath!)! as
        UITableViewCell
        print(indexPath?.row)
        
        let index = indexPath?.row
        
        if(userSaved[index!] != 0)
        {
            //delete from arrays and update table view as well as the userSaved job.
            let uname = UserDefaults.standard.value(forKey: "user_email")
            let pword = UserDefaults.standard.value(forKey: "user_password")
            
            print("About to get the user data with the following params: ")
            print(uname)
            print(pword)
            
            //make a copy of the array
            var updatedSavedJobs = userSaved
            //remove the index they have selected so that the patch removes that from their profile
            updatedSavedJobs.remove(at: index!)
            //reflect this change within the array that is actually seen on the page
            userSaved.remove(at: index!)
            //remove the menu item at that place too so the table view cells have the correct datas
            menuItems.remove(at: index!)
            
            let parameters: Parameters = [
                "savedjobs": updatedSavedJobs
            ]
            
            //function to update user categories
            //will require a patch request using alamofire
            Alamofire.request(USR_URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: uname! as! String, password: pword! as! String)
                .responseJSON { response in
                    if response.result.isSuccess
                    {
                        print("Successfully changed user saved jobs")
                        print(parameters)
                        //self.displayAlertMessage(userMessage: "Successfully removed saved job from your profile")
                        self.tblVeew.reloadData()
                        
                    }
                    else
                    {
                        print("error in addJobByID method")
                    }
            }
        }
        else
        {
            print("Out of bounds")
        }
    }
    

    @IBAction func menuButtonPressed(_ sender: Any)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    func getData(url: String)
    {
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
                print("Error getting JSON in the getData method")
            }
        }
        
    }

    
    func populateArrays(json : JSON)
    {
        print("populateArrays got called")
        
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            // Check if the JSON is an array otherwise nil
            if let jArray = json.array {
                
                //print(jsonArray[0]["description"].stringValue)
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
                /*
                 print("Title: \(jArray[i]["description"].stringValue)")
                 print("Institution Name: \(jArray[i]["institution_name"].stringValue)")
                 print("Department: \(jArray[i]["department"].stringValue)")
                 print("Date posted: \(jArray[i]["date_posting"].stringValue)")
                 
                 jobTitleLabel.text = jArray[i]["description"].stringValue
                 jobTitleLabel.numberOfLines = 0
                 jobTitleLabel.lineBreakMode = .byWordWrapping
                 jobTitleLabel.sizeToFit()
                 
                 
                 descriptionLabel.text = jArray[i]["text"].stringValue
                 descriptionLabel.numberOfLines = 0
                 descriptionLabel.lineBreakMode = .byWordWrapping
                 descriptionLabel.sizeToFit()
                 
                 let date = Date(timeIntervalSince1970: jArray[i]["date_posting"].double!)
                 let dateFormatter = DateFormatter()
                 dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                 dateFormatter.locale = NSLocale.current
                 dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
                 let strDate = dateFormatter.string(from: date)
                 dateLabel.text = strDate
                 
                 institution.text = jArray[i]["institution_name"].stringValue
                 institution.numberOfLines = 0
                 institution.lineBreakMode = .byWordWrapping
                 institution.sizeToFit()
                 */
                
                //lets just load the entire arrays
                let size = jArray.count
                for i in 0..<size
                {
                    self.jobTitles.append(jArray[i]["description"].stringValue)
                    
                    self.jobIDs.append(Int(jArray[i]["job_id"].intValue))
                }
                
                getUserData()
            }
        }
        
    }
    
    func getUserData()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        print("About to get the user data with the following params: ")
        print(uname)
        print(pword)
        
        Alamofire.request(USR_URL, method: .get).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Successful network call getting the user field data")
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.getFields(json: apiJSON)==1)
                    {
                        //do moar stuff
                        print("got the user data")
                    }
                    else
                    {
                        print("didnt get the user data")
                    }
                }
        }
        
    }
    
    func getFields(json: JSON) -> Int
    {
        
        print("getting user data fields")
        let body = json["body"].stringValue
        
        print(body.description)
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let saved = json["savedjobs"]
            
            print(saved.description)
            
            let size = saved.count
            
            print("Size of user saved jobs array is: ")
            print(size)
            
            for i in 0..<size
            {
                self.userSaved.append(saved[i].intValue)
                print("Just added to userSaved jobs array: ")
                print(saved[i])
            }
            self.populateMenuItems()
            
            return 1
        }
        
        return 0
    }
    
    func populateMenuItems()
    {
        //let size = userSaved.count
        
        print("user saved array in the populate menu items function")
        print(userSaved.description)
        
        print("Job Id array contents: ")
        print(jobIDs.description)
        
        var arrayToRemove: [Int] = []
        
        for i in 0..<userSaved.count
        {
            if(jobIDs.contains(userSaved[i]))
            {
                print("Detected job id value: ")
                print(userSaved[i])
                let index = jobIDs.index(of: userSaved[i])
                self.menuItems.append(jobTitles[index!])
                print("Just added : ")
                print(jobTitles[index!])
            }
            else
            {
                print("encountered a special snowflake.")
                //self.userSaved.remove(at: i)
                arrayToRemove.append(userSaved[i])
            }
        }
        
        for i in 0..<arrayToRemove.count
        {
            if(userSaved.contains(arrayToRemove[i]))
            {
                let index = userSaved.index(of: arrayToRemove[i])
                userSaved.remove(at: index!)
            }
        }
        
        print("User saved: ")
        print(userSaved.description)
        
        print("Menu items: ")
        print(menuItems.description)
        
        //update the user fields because sometimes jobs are done away with
        self.updateUserFields()
        
        tblVeew.reloadData()
        
        
    }
    
    func updateUserFields()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        let updatedSavedJobs = userSaved
        
        let parameters: Parameters = [
            "savedjobs": updatedSavedJobs
        ]
        
        //function to update user categories
        //will require a patch request using alamofire
        Alamofire.request(USR_URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    print("Successfully changed stuff")
                    print(parameters)
                    //self.displayAlertMessage(userMessage: "Successfully added job to saved jobs list!")
                }
                else
                {
                    print("error in update user fields method")
                }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch((indexPath as NSIndexPath).row)
        {
        case 0:
            if(userSaved[0] != 0)
            {
                let data = userSaved[0]
                //let destinationViewController = ExpandedJobCardViewController()
                //destinationViewController.passedID = data
                //present(destinationViewController, animated: true, completion: nil)
                print("This should take the user to the expanded job card page")
                let expandedJobsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpandedJobCardViewController") as! ExpandedJobCardViewController
                
                expandedJobsViewController.passedID = data
                
                let expandedJobsNav = UINavigationController(rootViewController: expandedJobsViewController)
                
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                
                if((appDelegate.drawerContainer) == nil){
                    print("drawer container is null")
                    
                }
                
                appDelegate.drawerContainer!.centerViewController = expandedJobsNav
            }
            else
            {
                print("Not handled. null value.")
            }
            
            break
            
        default:
            let index = indexPath.row
            
            print("Index selected : ")
            
            print(index)
            
            if(userSaved[index] != 0)
            {
                let data = userSaved[index]
                print("This should take the user to the expanded job card page")
                let expandedJobsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpandedJobCardViewController") as! ExpandedJobCardViewController
                
                expandedJobsViewController.passedID = data
                
                let expandedJobsNav = UINavigationController(rootViewController: expandedJobsViewController)
                
                let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                
                
                if((appDelegate.drawerContainer) == nil){
                    print("drawer container is null")
                    
                }
                
                appDelegate.drawerContainer!.centerViewController = expandedJobsNav
            }
            else
            {
                print("Not handled. null value.")
            }
            
            break
            
        }
    }




}
