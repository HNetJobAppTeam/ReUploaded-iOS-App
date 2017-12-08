//
//  RegistrationViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 8/22/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationViewController: UIViewController {
    
    //api url
    let API_URL = "https://jobapp.h-net.org/1.0/Registration"
    
    //the text fields we are collecting user sign in data from
    @IBOutlet weak var FirstNameTxt: UITextField!
    
    @IBOutlet weak var LastNameTxt: UITextField!
    
    @IBOutlet weak var EmailTxt: UITextField!
    
    @IBOutlet weak var PasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

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
    

    @IBAction func signUpButtonTapped(_ sender: Any)
    {
        //variables for holding the user input
        let userEmail = EmailTxt.text
        
        let userPassword = PasswordTxt.text
        
        
        if((userEmail?.isEmpty)! || (userPassword?.isEmpty)!)
        {
            displayAlertMessage(userMessage: "All fields must be filled out in order to create your account")
        }
        
        // Send HTTP POST
        let parameters: Parameters = [
            "password": userPassword!,
            "email": userEmail!
        ]
        
        postData(parameters: parameters)
        
        
        
    }
    
    //function for displaying Alert
    func displayAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    func postData(parameters: Parameters){
        print("Parameters: ")
        print(parameters)
        Alamofire.request(API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (response) in
            
            if response.result.isSuccess {
                print("Successfully registered new user")
                print(parameters["email"]!)
                print(parameters["password"]!)
                UserDefaults.standard.setValue(parameters["email"]!, forKey: "user_email")
                UserDefaults.standard.setValue(parameters["password"]!, forKey: "user_password")
                UserDefaults.standard.synchronize()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.buildNavigationDrawer()
                
                
            }
            else
            {
                print("failure registering new user")
                self.displayAlertMessage(userMessage: "Error registering your account.")
            }
            
            
        }
        
        
        
        
    }

}
