//
//  SearchCriteriaViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 11/28/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchCriteriaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var keywordText: UITextField!
    
    @IBOutlet weak var institutionPicker: UIPickerView!
    
    @IBOutlet weak var countryPicker: UIPickerView!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    var institutionArray: [String] = ["Any"]
    var countryArray: [String] = ["Any"]
    var countryInts: [Int] = [-1]
    var stateArray: [String] = ["Any"]
    var stateInts: [Int] = [-1]
    
    let Country_URL = "https://jobapp.h-net.org/1.0/Country"
    let State_URL = "https://jobapp.h-net.org/1.0/State"
    let INS_URL = "https://jobapp.h-net.org/1.0/InstitutionType"
    
    
    var selectedCountryRow = 0
    var selectedStateRow = 0
    var selectedInstitutionRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchCriteriaViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        searchBtn.layer.cornerRadius = 10
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        statePicker.dataSource = self
        statePicker.delegate = self
        institutionPicker.dataSource = self
        institutionPicker.delegate = self
        
        
        getCountries()
        getStates()
        getInstitutions()

        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func searchButtonPressed(_ sender: Any)
    {
        print("State row: \(selectedStateRow)")
        print("Institution row \(selectedInstitutionRow)")
        print("Country row: \(selectedCountryRow)")
        print(institutionArray[selectedInstitutionRow])
        
        
        let state_id = stateInts[selectedStateRow]
        let country_id = countryInts[selectedCountryRow]
        let instituionType = institutionArray[selectedInstitutionRow]
        let keyword = keywordText.text
 
        
        let searchResultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        
        searchResultsViewController.country_id = country_id
        searchResultsViewController.keyword = keyword!
        searchResultsViewController.state_id = state_id
        searchResultsViewController.institutionType = instituionType
 
        
        let resultsNav = UINavigationController(rootViewController: searchResultsViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if((appDelegate.drawerContainer) == nil){
            print("drawer container is null")
            
        }
        
        appDelegate.drawerContainer!.centerViewController = resultsNav
        
        
    }
   
    @IBAction func menuButtonPressed(_ sender: Any)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    func getCountries()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(Country_URL, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                self.populateCountryArray(json : apiJSON)
            }
            else
            {
                print("Error getting JSON in the getCountries function")
                self.getCountries()
            }
        }

    }
    
    func populateCountryArray(json : JSON)
    {
        
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            let json = JSON(data: dataFromString)
            
            // Check if the JSON is an array otherwise nil
            if let jArray = json.array
            {
              
                
                //load the entire arrays
                let size = jArray.count
                
                for i in 0..<size
                {
                    //print("i is : \(i) :")
                    //print(jArray[i]["country_name"].stringValue)
                    countryArray.append(jArray[i]["country_name"].stringValue)
                    countryInts.append(jArray[i]["country_id"].intValue)
                    
                }
                
                //print(countryArray.description)
                //print(countryInts.description)
                countryPicker.reloadAllComponents()
                
            }
            else
            {
                print("data format is not an array")
            }
        }
        
    }
    
    func getStates()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(State_URL, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                self.populateStateArray(json : apiJSON)
            }
            else
            {
                print("Error getting JSON in the getStates function")
                self.getStates()
            }
        }
        
    }
    
    func populateStateArray(json : JSON)
    {
        
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            let json = JSON(data: dataFromString)
            
            // Check if the JSON is an array otherwise nil
            if let jArray = json.array
            {
                
                
                //load the entire arrays
                let size = jArray.count
                
                for i in 0..<size
                {
                    //print("i is : \(i) :")
                    //print(jArray[i]["country_name"].stringValue)
                    stateArray.append(jArray[i]["state_name"].stringValue)
                    stateInts.append(jArray[i]["state_id"].intValue)
                    
                }
                
                print(stateArray.description)
                print(stateInts.description)
                statePicker.reloadAllComponents()
                
            }
            else
            {
                print("data format is not an array")
            }
        }
        
    }
    
    func getInstitutions()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(INS_URL, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                self.populateInstitutionArray(json : apiJSON)
            }
            else
            {
                print("Error getting JSON in the getInstitution function")
                self.getInstitutions()
            }
        }
        
    }
    
    func populateInstitutionArray(json : JSON)
    {
        
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            let json = JSON(data: dataFromString)
            
            // Check if the JSON is an array otherwise nil
            if let jArray = json.array
            {
                
                
                //load the entire arrays
                let size = jArray.count
                
                print("Size: \(size)")
                
                for i in 0..<size
                {
                    institutionArray.append(jArray[i].stringValue)
                    
                }
                
                print(institutionArray.description)
                
                institutionPicker.reloadAllComponents()
                
            }
            else
            {
                print("data format is not an array")
            }
        }
        
    }



    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.tag==0)
        {
            return institutionArray.count
        }
        if(pickerView.tag==1)
        {
            return countryArray.count
        }
        else
        {
            return stateArray.count
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView.tag==0)
        {
            return institutionArray[row]
        }
        if(pickerView.tag==1)
        {
            
            return countryArray[row]
        }
        else
        {
            return stateArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.tag==0)
        {
                //print(institutionArray[row])
                selectedInstitutionRow = row
                print("Selected institution row: \(selectedInstitutionRow)")
        }
        if(pickerView.tag==1)
        {
            //print(countryArray[row])
            selectedCountryRow = row
            print("Selected Country row: \(selectedCountryRow)")
        }
        else
        {
            //print(stateArray[row])
            selectedStateRow = row
            print("State row: \(selectedStateRow)")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            pickerLabel?.textAlignment = .center
        }
        
        if(pickerView.tag==0)
        {
            if(!institutionArray.isEmpty)
            {
                pickerLabel?.text = institutionArray[row]
                pickerLabel?.textColor = UIColor.white
            }
            else
            {
                pickerLabel?.text = "Empty"
                pickerLabel?.textColor = UIColor.white
            }
            return pickerLabel!
            
        }
        if(pickerView.tag==1)
        {
            if(!countryArray.isEmpty)
            {
                pickerLabel?.text = countryArray[row]
                pickerLabel?.textColor = UIColor.white
            }
            else
            {
                pickerLabel?.text = "Empty"
                pickerLabel?.textColor = UIColor.white
            }
            return pickerLabel!
        }
        else
        {
            if(!stateArray.isEmpty)
            {
                pickerLabel?.text = stateArray[row]
                pickerLabel?.textColor = UIColor.white
            }
            else
            {
                pickerLabel?.text = "Empty"
                pickerLabel?.textColor = UIColor.white
            }
            return pickerLabel!
        }
 
        
    }


    
    
    

}
