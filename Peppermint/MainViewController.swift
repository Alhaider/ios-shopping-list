//
//  MainViewController.swift
//  Peppermint
//
//  Created by Luca Kaufmann on 27/11/2016.
//  Copyright © 2016 Luca Kaufmann. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [storyboard.instantiateViewController(withIdentifier: "MealsVC") , storyboard.instantiateViewController(withIdentifier: "ShoppingListVC")],
            titles: ["Meals", "Shopping List"])
        
        view.addSubview(slidingContainerViewController.view)
        //TODO: Auth stuff
//        Auth.auth().addStateDidChangeListener { auth, user in
//            guard let user = user else { return }
//            self.user = PMUser(authData: user)
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
