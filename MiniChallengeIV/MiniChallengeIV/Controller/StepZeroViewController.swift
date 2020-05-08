//
//  StepZeroViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 08/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class StepZeroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Disappear")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
