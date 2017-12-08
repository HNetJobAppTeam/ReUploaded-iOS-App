//
//  SearchResultsViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 11/28/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var state_id = 0
    var country_id = 0
    var keyword = ""
    var institutionType = ""
    var menuItems: [String] = []
    let API_URL = "https://jobapp.h-net.org/1.0/Job"
    
    
    @IBOutlet weak var tblView: UITableView!
    
    //array of the job titles
    var jobTitles: [String] = []
    
    var filteredJobTitles: [String] = []
    
    //array of job text
    var jobDescriptions :[String] = []
    
    var filteredJobDescriptions: [String] = []
    
    //array for state_id
    var stateArray: [Int] = []
    
    var filteredStateArray: [Int] = []
    
    //array for country_id
    var countryArray: [Int] = []
    
    var filteredCountryArray: [String] = []
    
    //array for institution types
    var institutionTypes: [String] = []
    
    var filteredInstitutionTypes: [String] = []
    //going to need jobID array to pass the correct job to the saved and hidden jobs section
    var jobIDs: [Int] = []
    
    var filteredJobsIDs: [Int] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("State id: \(state_id)")
        print("Country id : \(country_id)")
        print("Keyword: \(keyword)")
        print("Institution Type: \(institutionType)")
        
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
        myCell.textLabel?.text = menuItems[(indexPath as NSIndexPath).row]
        myCell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        
        return myCell
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
                    self.jobIDs.append(Int(jArray[i]["job_id"].intValue))
                    self.countryArray.append(jArray[i]["country_id"].intValue)
                    self.institutionTypes.append(jArray[i]["institution_type"].stringValue)
                    self.stateArray.append(jArray[i]["state_id"].intValue)
                }
                
                filterData()
                
            }
        }
        
    }

    func filterData()
    {
        
        //give the user only what they specified
        let size = jobIDs.count
        
        for i in 0..<size
        {
            var check = false
            
            if(jobTitles[i].range(of:keyword) != nil)
            {
                check = true
            }
            if(jobDescriptions[i].range(of:keyword) != nil)
            {
                check = true
            }
            
            if(((countryArray[i] == country_id)||(country_id == -1)) && ((stateArray[i] == state_id) || (state_id == -1)) && ((institutionTypes[i] == institutionType)||(institutionType == "Any"))&&((check) || (keyword=="")))
            {
                    menuItems.append(jobTitles[i])
                    filteredJobsIDs.append(jobIDs[i])
                    print("Added to menuitems")
            }
            
        }
        print(menuItems.description)
        
        
        
        tblView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch((indexPath as NSIndexPath).row)
        {
        case 0:
            if(filteredJobsIDs[0] != 0)
            {
                let data = filteredJobsIDs[0]
                
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
            
            if(filteredJobsIDs[index] != 0)
            {
                let data = filteredJobsIDs[index]
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

    
    @IBAction func menuButtonPressed(_ sender: Any)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }

  

}
