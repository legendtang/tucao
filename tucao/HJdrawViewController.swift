//
//  HJdrawViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/23.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJdrawViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        avatar.layer.cornerRadius=avatar.frame.width/2
        avatar.layer.borderWidth=1
        avatar.layer.borderColor=UIColor.white.cgColor
        avatar.layer.masksToBounds=true
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
