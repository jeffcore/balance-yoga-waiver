//
//  EndViewController.swift
//  BalanceYogaWaiver
//
//  Created by rixcore on 11/7/18.
//  Copyright © 2018 rixcore. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var signUpName: UILabel!
    
    var customer: Customer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restartButton.layer.cornerRadius = 5
        signUpName.text = "New Client: \(customer!.firstName) \(customer!.lastName)"
        
//        _ = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { timer in
//            DispatchQueue.main.async{
//                self.performSegue(withIdentifier: "RestartSegue", sender: self)
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickRestartButton(_ sender: Any) {
        performSegue(withIdentifier: "RestartSegue", sender: self)        
    }   
    
}
