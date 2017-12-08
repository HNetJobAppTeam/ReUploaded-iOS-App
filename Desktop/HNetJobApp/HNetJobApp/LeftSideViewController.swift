//
//  LeftSideViewController.swift
//  HNetJobApp
//
//  Created by HNet GroupNine on 9/3/17.
//  Copyright © 2017 HNet. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuItems:[String] = ["My Account","Search Jobs", "Saved Jobs","Hidden Jobs", "Advanced Search", "About HNet", "Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch((indexPath as NSIndexPath).row)
        {
        case 0:
            let myAccountViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            
            let accountNav = UINavigationController(rootViewController: myAccountViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            if((appDelegate.drawerContainer) == nil){
                print("drawer container is null")
                
            }
            
            appDelegate.drawerContainer!.centerViewController = accountNav
            
            appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
        case 1:
            let mainPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            
            let mainNav = UINavigationController(rootViewController: mainPageViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            if((appDelegate.drawerContainer) == nil){
                print("drawer container is null")
                
            }
            
            appDelegate.drawerContainer!.centerViewController = mainNav
            
            appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
        case 2:
            print("This should take the user to the saved jobs page")
            let savedJobsViewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedJobsViewController") as! SavedJobsViewController
            
            let savedJobsNav = UINavigationController(rootViewController: savedJobsViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            if((appDelegate.drawerContainer) == nil){
                print("drawer container is null")
                
            }
            
            appDelegate.drawerContainer!.centerViewController = savedJobsNav
            
            appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
        case 3:
            print("This should take the user to the hidden jobs page")
            let hiddenJobsViewController = self.storyboard?.instantiateViewController(withIdentifier: "HiddenJobsViewController") as! HiddenJobsViewController
            
            let hiddenJobsNav = UINavigationController(rootViewController: hiddenJobsViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            if((appDelegate.drawerContainer) == nil){
                print("drawer container is null")
                
            }
            
            appDelegate.drawerContainer!.centerViewController = hiddenJobsNav
            
            appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
            
        case 4:
            print("This should take the user to the search criteria page")
            let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchCriteriaViewController") as! SearchCriteriaViewController
            
            let searchNav = UINavigationController(rootViewController: searchViewController)
            
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            if((appDelegate.drawerContainer) == nil){
                print("drawer container is null")
                
            }
            
            appDelegate.drawerContainer!.centerViewController = searchNav
            
            appDelegate.drawerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            
            break
            
            
        case 5:
            
            if let url = NSURL(string: "https://networks.h-net.org/")
            {
                UIApplication.shared.openURL(url as URL)
            }
            
            break
        case 6:
            
            UserDefaults.standard.removeObject(forKey: "user_email")
            UserDefaults.standard.removeObject(forKey: "user_password")
            //UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.synchronize()
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
            let signInNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = signInNav
            
            break
            
        default:
            print("Not handled")
        }
    }
    

}
