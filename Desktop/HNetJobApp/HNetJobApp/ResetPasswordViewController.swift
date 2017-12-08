//
//  ResetPasswordViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 11/26/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ResetPasswordViewController: UIViewController {
    
    var API_URL = "https://jobapp.h-net.org/1.0/Reset"
    
    
    @IBOutlet weak var emailTxtField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.dismissKeyboard))
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
    
    @IBAction func menuButtonPressed(_ sender: Any)
    {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    //function for displaying Alert
    func displayAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }

    @IBAction func resetPasswordPressed(_ sender: Any)
    {
        //let uname2 = UserDefaults.standard.value(forKey: "user_email")
        
        let uname = emailTxtField.text
        
        
        
        if(!(uname!.isEmpty))
        {
            let parameters: Parameters = [
                "email": uname!
            ]
        
            print("API_URL is: ")
            print(API_URL)
        
        
            Alamofire.request(API_URL, method: .get, parameters: parameters, encoding: URLEncoding.default).responseString { (response) in
                
                if response.result.isSuccess
                {
                    print(response)
                    print(response.result)
                    
                    print("Successfully changed email")
                    print(parameters)
                    self.displayAlertMessage(userMessage: "Success.  Check your email for temporary password.")
                    
                }
                else
                {
                    print("failure changing password")
                    self.displayAlertMessage(userMessage: "Failure to change password. Try again later.")
                }
                
                
            }
        }
        else
        {
            self.displayAlertMessage(userMessage: "You must input an email.")
        }
    }
}
