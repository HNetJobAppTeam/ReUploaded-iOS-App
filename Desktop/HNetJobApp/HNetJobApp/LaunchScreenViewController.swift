//
//  LaunchScreenViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 11/28/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LaunchScreenViewController: UIViewController {
    
    //the user data api
    let SPS_URL = "https://jobapp.h-net.org/1.0/Sponsor"
    
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // getSponsorImage()
        
        print("View did load")
        
        let userEmail = UserDefaults.standard.string(forKey: "user_email")
        
        if(userEmail != nil)
        {
            getSponsorImage()
            //perform(#selector(LaunchScreenViewController.goToMain), with: nil, afterDelay: 10)
        }
        else
        {
            perform(#selector(LaunchScreenViewController.showNextView), with: nil, afterDelay: 4)
        }
    }
    
    func showNextView()
    {
            print("Show next view")
            
            performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    func goToMain()
    {
        let mainPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        
        let mainNav = UINavigationController(rootViewController: mainPageViewController)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if((appDelegate.drawerContainer) == nil){
            print("drawer container is null")
            appDelegate.buildNavigationDrawer()
            
        }
        
        appDelegate.drawerContainer!.centerViewController = mainNav
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSponsorImage()
    {
        let uname = UserDefaults.standard.value(forKey: "user_email")
        let pword = UserDefaults.standard.value(forKey: "user_password")
        
        
        if(uname != nil)
        {
        

        
        Alamofire.request(SPS_URL, method: .get).authenticate(user: uname! as! String, password: pword! as! String)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Successful network call for sponsor image")
                    
                    let apiJSON : JSON = JSON(response.result.value!)
                    if(self.displayImage(json: apiJSON)==1)
                    {
                        
                        print("other function worked too")
                        
                    }
                    else
                    {
                        print("error has occured getting the image")
                    }
                }
            }
        }
        
        
        
    }
    
    func displayImage(json: JSON) -> Int
    {
        
        let body = json["body"].stringValue
        //print(body)
        
        if let dataFromString = body.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            if let jArray = json.array
            {
                //lets just load the entire arrays
                let size = jArray.count
                print("Size of the entire json array is: ")
                print(size)
                
                let encodedImageData = jArray[2].stringValue
                let decodedData = Data(base64Encoded: encodedImageData, options: .ignoreUnknownCharacters)
                let image = UIImage(data: decodedData!)
                imageView.image = image
                perform(#selector(LaunchScreenViewController.goToMain), with: nil, afterDelay: 5)
                
            }
            else
            {
                print("could not convert to array")
            }
            
            return 1
        }
        
        
        
        
        return 0
    }
    

  

}
