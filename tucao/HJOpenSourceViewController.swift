//
//  HJOpenSourceViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/12/12.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJOpenSourceViewController: UIViewController
{
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        textView.contentOffset=CGPoint.init(x: 0, y: -128)
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
