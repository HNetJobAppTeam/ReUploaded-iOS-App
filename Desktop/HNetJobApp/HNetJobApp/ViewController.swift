//
//  ViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 8/21/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let API_URL = "https://jobapp.h-net.org/1.0/User"

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        print("Checking for default values...")
        var a = isKeyPresentInUserDefaults(key: "user_email")
        print(a)
        
        //rounded button edges
        loginBtn.layer.cornerRadius = 10
        forgotPasswordBtn.layer.cornerRadius = 10
        
        //hide the navigation bar in case you are taken back here, especially from the log out button.
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func logInButtonTapped(_ sender: Any)
    {
        let userEmailAddress = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        
        if(userEmailAddress!.isEmpty || userPassword!.isEmpty)
        {
            // Display an alert message
            let myAlert = UIAlertController(title: "Alert", message:"All fields are required to be fill in", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        Alamofire.request(API_URL, method: .get).authenticate(user: userEmailAddress!, password: userPassword!)
            .responseJSON { response in
                //debugPrint(response)
                //print(response.data!)
                if response.result.isSuccess {
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.setDefaults(json: apiJSON)==1)
                    {
                        print("Password: ")
                        UserDefaults.standard.setValue(userPassword, forKey: "user_password")
                        print("\(UserDefaults.standard.value(forKey: "user_password")!)")
                        UserDefaults.standard.synchronize()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.buildNavigationDrawer()
                    }
                    else
                    {
                        print("error has occured during login")
                    }
                }
        }

    }
    
    func setDefaults(json: JSON)-> Int
    {
        
        let body = json["body"].stringValue
       // print(body)
       
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            let email = json["email"].stringValue
            print(email)
            
            UserDefaults.standard.setValue(email, forKey: "user_email")
            print("\(UserDefaults.standard.value(forKey: "user_email")!)")
            return 1
        }
        return 0
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
   
    
}
