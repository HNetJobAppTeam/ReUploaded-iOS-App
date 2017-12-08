//
//  MyAccountViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 8/30/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class MyAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var menuView: UIView!
    
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    var i = 0
    
    @IBOutlet weak var poop: UILabel!
    
    //api url
    let API_URL = "https://jobapp.h-net.org/1.0/Category"
    
    let USR_URL = "https://jobapp.h-net.org/1.0/User"
    
    
    
    //variable for the user to select their fields from
    @IBOutlet weak var selectFieldsPicker: UIPickerView!
    
    //variable for the user's selected options
    @IBOutlet weak var userSelectedPicker: UIPickerView!
    
    //need array for all of the different fields that the user can slect from
    var pickerViewData: [String] = []
    
    var userFields: [String] = []
    
    var tempArray: [String] = []
    
    //variable representing the user's selection within the Select Fields picker View
    var selectedField = ""
    
    
    
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        poop.text = ""
        
        //lets get the data first
        getData()
        
        
        
        self.userSelectedPicker.reloadAllComponents()
        
        
        //give the buttons a rounded edge for professional look

        changePasswordBtn.layer.cornerRadius = 10
        
        selectFieldsPicker.dataSource = self
        userSelectedPicker.dataSource = self
        selectFieldsPicker.delegate = self
        userSelectedPicker.delegate = self
    }
    
    //modify user profile to get rid of some of the category filter shit so that the other array actually loads things and stuff
    func changeCategories(intArr: [Int])
    {
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        var notify = true
        
        if(notificationSwitch.isOn)
        {
            notify = true
        }
        else
        {
            notify = false
        }
        
        let strVal = notify.description
        
        
        let parameters: Parameters = [
            "categoryfilter": intArr,
            "notification": ["isTurnedOn": strVal, "userType": "app"]
        ]
        
        //function to update user categories
        //will require a patch request using alamofire
        Alamofire.request(USR_URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    print("Successfully updated account with the following paramters: ")
                    print(parameters)
                    
                    self.displayAlertMessage(userMessage: "Account successfully updated")
                    
                    
                }
                else
                {
                    print("error in changeCategories method")
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
    
    
    //function that will make sure every item in the user fields does not appear again in the still can be chosen pickerview
    func deleteInCommonFields()
    {
        print("In the delete in common fields function")
        //loop through all of the user fields and if they are in the other picker view's data, remove them
        for i in 0..<userFields.count
        {
            print("setting temp to : ")
            print(userFields[i])
          var temp = userFields[i]
            if(pickerViewData.contains(temp))
            {
                let index = self.pickerViewData.index(of:temp)
                self.pickerViewData.remove(at: index!)
                print("deleting the following field they had in common")
                print(temp)
            }
        }
        
        print("What I should be left with in the user fields array is: ")
        print(userFields.description)
        self.selectFieldsPicker.reloadAllComponents()
        self.userSelectedPicker.reloadAllComponents()
    }
    
    func getUserData()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(USR_URL, method: .get).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.getFields(json: apiJSON)==1)
                    {
                       print("Success")
                    }
                    else
                    {
                        print("error has occured getting the datas")
                    }
                }
        }
        
    }
    
    func getFields(json: JSON) -> Int
    {
        let body = json["body"].stringValue
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let categories = json["categoryfilter"]
            
           
            
            let size = categories.count
            
            for i in 0..<size
            {
                self.userFields.append(categories[i].stringValue)
            }
            self.getStringValues()
            
            return 1
        }
        
        return 0
    }
    
    func getStringValues(){
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(API_URL, method: .get).authenticate(user: uname as! String , password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                let body = apiJSON["body"].stringValue
                //print(body.description)
                if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    
                    // Check if the JSON is an array otherwise nil
                    if let jsonArray = json.array {
                        
                        for i in 0..<jsonArray.count {
                            if(self.userFields.contains(jsonArray[i]["category_id"].stringValue))
                            {
                                //self.tempArray.append(jsonArray[i]["category_id"].stringValue)
                                let index = self.userFields.index(of:jsonArray[i]["category_id"].stringValue)
                                self.userFields.remove(at: index!)
                                self.userFields.append(jsonArray[i]["category_name"].stringValue)
                            }
                            else
                            {
                                //print("hooooowwwww???????")
                            }
                        }
                        self.userSelectedPicker.reloadAllComponents()
                        
                        self.deleteInCommonFields()
                        
                    }
                    
                    
                    
                }
                
                
            }
            else {
                print("Error getting JSON")
            }
        }
        
        
    }
    
    
    func getData()
    {
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        Alamofire.request(API_URL, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess {
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                let body = apiJSON["body"].stringValue
                
                if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    
                    // Check if the JSON is an array otherwise nil
                    if let jsonArray = json.array {
                        
                        for i in 0..<jsonArray.count
                        {
                            
                                self.pickerViewData.append(jsonArray[i]["category_name"].stringValue)
                        }
                        self.selectFieldsPicker.reloadAllComponents()

                    }
                    
                    
                    self.getUserData()
                }

                
            }
            else
            {
                print("Error getting JSON")
            }
        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.tag==1)
        {
            return pickerViewData.count
        }
        else
        {
          return userFields.count
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView.tag==1)
        {
            
            return pickerViewData[row]
        }
        else
        {
            return userFields[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.tag==1)
        {
            selectedField = pickerViewData[row]
            poop.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
            poop.text = pickerViewData[row]

            print(pickerViewData[row])
        }
        else
        {

            print(userFields[row])
        }
        
    }
    
   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            pickerLabel?.textAlignment = .center
        }
    if(pickerView.tag==1)
    {
        if(!pickerViewData.isEmpty)
        {
            pickerLabel?.text = pickerViewData[row]
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
            if(!userFields.isEmpty)
            {
                pickerLabel?.text = userFields[row]
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
    
    @IBAction func selectFieldBtn(_ sender: UIButton)
    {
        if(pickerViewData.isEmpty){
            return
        }
        
        //in case the user wants whatever is at the top of the list already
        if (selectedField == "")
        {
            selectedField = pickerViewData[0]
        }
        
        let row = self.selectFieldsPicker.selectedRow(inComponent: 0)
        selectedField = pickerViewData[row]
        
        //function that takes the selected field and adds to the user's fields
        //remove the item from the first list
        let index = pickerViewData.index(of:selectedField)
        pickerViewData.remove(at: index!)
        
        
        //refresh
        self.selectFieldsPicker.reloadAllComponents()
        
        
        //add the item to the second
        userFields.append(selectedField)
        print(userFields)
        self.userSelectedPicker.reloadAllComponents()
        self.selectFieldsPicker.selectRow(0, inComponent: 0, animated: true)
        
    }
    
    @IBAction func removeField(_ sender: UIButton)
    {
        //this function is pretty much the opposite of the above function
        //it is for when the user would like to remove a field from their list
        
        //make sure that there is some data in the array before letting the user do something stupid
        if (userFields.isEmpty)
        {
            //take no action if the array is empty
            return
        }
        
        //in case the user wants whatever is at the top of the list already
        var itemToRemove = ""
        
        if (itemToRemove == "")
        {
            itemToRemove = userFields[0]
        }
        
        let row = self.userSelectedPicker.selectedRow(inComponent: 0)
        itemToRemove = userFields[row]
        
        //function that takes the selected field and adds to the user's fields
        //remove the item from the first list
        let index = userFields.index(of:itemToRemove)
        userFields.remove(at: index!)
        
        
        //refresh
        self.userSelectedPicker.reloadAllComponents()
        
        
        //add the item to the second
        pickerViewData.append(itemToRemove)
        print(userFields)
        self.selectFieldsPicker.reloadAllComponents()
        self.userSelectedPicker.selectRow(0, inComponent: 0, animated: true)

    }
    
    @IBAction func menuButtonPressed(_ sender: Any)
    {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    func getNumberValues()
    {
        //make a copy of the array to work with
        var temp = userFields
        //print(temp.description)
        var intArrayOfGoodShit:[Int] = []
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")

        
     //convert the strings back to numbers
        Alamofire.request(API_URL, method: .get).authenticate(user: uname as! String, password: pword as! String).responseJSON {
            response in
            if response.result.isSuccess
            {
                
                
                let apiJSON : JSON = JSON(response.result.value!)
                
                let body = apiJSON["body"].stringValue
                
                if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false)
                {
                    let json = JSON(data: dataFromString)
                    
                    // Check if the JSON is an array otherwise nil
                    if let jsonArray = json.array {
                        
                        for i in 0..<jsonArray.count
                        {
                            if(temp.contains(jsonArray[i]["category_name"].stringValue))
                            {
                                let index = temp.index(of:jsonArray[i]["category_name"].stringValue)
                                temp.remove(at: index!)
                                temp.append(jsonArray[i]["category_id"].stringValue)
                                //print("Changed shit")
                                //print(temp.description)
                                let myStr = jsonArray[i]["category_id"].stringValue
                                let myInt = Int(myStr)
                                intArrayOfGoodShit.append(myInt!)
                                print("Appended: ")
                                print(intArrayOfGoodShit)
                            }
                            else
                            {
                                
                            }
                        }
                        self.changeCategories(intArr: intArrayOfGoodShit)
                    }
                }
            }
            else
            {
                print("error getting the  JSON")
            }
        }
        
        return
    }
    

    @IBAction func pleaseWork(_ sender: Any)
    {
        
        getNumberValues()
        
    }


    
}
