//
//  fullViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/4.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit


class fullViewController: UIViewController {

    public var playerView:UIView?;
    
    override var shouldAutorotate: Bool
        {
        return true;
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
        {
        return UIInterfaceOrientationMask.landscapeLeft;
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.addSubview(playerView!)
        
        let s = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        s.backgroundColor=UIColor.red;
        s.addTarget(self, action:#selector(fullViewController.exit) , for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(s);
        
    }

    @objc func exit()
    {
        self.dismiss(animated: false, completion: nil)
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
