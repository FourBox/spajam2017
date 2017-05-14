//
//  ResultViewController.swift
//  spajam2017
//
//  Created by Yuta on 2017/05/14.
//  Copyright © 2017年 Yuta. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ResultViewController: UIViewController {
    
    var speeds: [Float]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(true){
            print("debug")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension String {
    
    func removed(string: String) -> String {
        if let range = self.range(of: string) {
            var mutatingSelf = self
            mutatingSelf.replaceSubrange(range, with: "")
            return mutatingSelf.removed(string: string)
        }
        return self
    }
}

