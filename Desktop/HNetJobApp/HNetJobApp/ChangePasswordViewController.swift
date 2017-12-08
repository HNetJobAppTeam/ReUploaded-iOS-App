//
//  ChangePasswordViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 11/28/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var text1: UITextField!
    
    
    @IBOutlet weak var text2: UITextField!
    
    
    @IBOutlet weak var saveBtn: UIButton!
    
    //the user data api
    let USR_URL = "https://jobapp.h-net.org/1.0/User"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        saveBtn.layer.cornerRadius = 10

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
    
    func displayAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Notification", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    

  
    @IBAction func changePasswordBtnPress(_ sender: Any)
    {
        
        let pword1 = text1.text
        
        let pword2 = text2.text
        
        if(pword1!.isEmpty || pword2!.isEmpty)
        {
            // Display an alert message
            let myAlert = UIAlertController(title: "Alert", message:"All fields are required to be fill in", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        if(pword1 != pword2!)
        {
            // Display an alert message
            let myAlert = UIAlertController(title: "Alert", message:"passwords do not match", preferredStyle: UIAlertControllerStyle.alert);
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            myAlert.addAction(okAction);
            self.present(myAlert, animated: true, completion: nil)
            return
        }
        
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        let parameters: Parameters = [
            "password": pword1
        ]
        
        //function to update user categories
        //will require a patch request using alamofire
        Alamofire.request(USR_URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess
                {
                    print("New password: ")
                    print(parameters)
                    self.displayAlertMessage(userMessage: "Successfully chnaged password")
                    
                    
                }
                else
                {
                    print("password not changed")
                    self.displayAlertMessage(userMessage: "Error. Password not changed.")
                }
        }
        
        
        
        
    }

}
