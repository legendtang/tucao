//
//  HJDanmakusetupTableViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/23.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJDanmakusetupTableViewController: UITableViewController {

    @IBOutlet weak var countSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var transparentSlider: UISlider!
    @IBOutlet weak var countLable: UILabel!
    @IBOutlet weak var speedLable: UILabel!
    @IBOutlet weak var transparentLable: UILabel!
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let  userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.set(Int(countSlider.value), forKey: "maxDanmakuCount")
        userDefaults.set(Double(speedSlider.value), forKey: "DanmakuSpeed")
        userDefaults.set(transparentSlider.value, forKey: "DanmakuTransparent")
        userDefaults.synchronize()
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let  userDefaults:UserDefaults = UserDefaults.standard
        
        let a:Int? = userDefaults.integer(forKey: "maxDanmakuCount")
        if a != nil
        {
            countSlider.value=Float(a!)
            if a == 80
            {
                countLable.text="不限制"
            }
            else
            {
                countLable.text="\(a!)条"
            }
        }
        else
        {
            countSlider.value=30
            countLable.text="30条"
        }
        
        let b:Double? = userDefaults.double(forKey: "DanmakuSpeed")
        if b != nil
        {
            speedSlider.value=Float(b!)
            let r:String=String.init(format: "%.1f", b!)
            speedLable.text="\(r)秒"
        }
        else
        {
            speedSlider.value=5
            speedLable.text="5秒"
        }
        
        let c:Float? = userDefaults.float(forKey: "DanmakuTransparent")
        if c != nil
        {
            transparentSlider.value=c!
            transparentLable.text="\(Int(c!*100))%"
        }
        else
        {
            transparentSlider.value=1
            transparentLable.text="100%"
        }
        
        countSlider.addTarget(self, action: #selector(self.countChanged), for: UIControlEvents.valueChanged)
        speedSlider.addTarget(self, action: #selector(self.speedChanged), for: UIControlEvents.valueChanged)
        transparentSlider.addTarget(self, action: #selector(self.transparentChanged), for: UIControlEvents.valueChanged)
    }
    
    func countChanged()
    {
        if countSlider.value == 80
        {
            countLable.text="不限制"
        }
        else
        {
            countLable.text="\(Int(countSlider.value))条"
        }
    }
    
    func speedChanged()
    {
        let r:String=String.init(format: "%.1f", speedSlider.value)
        //            speedLable.text="\(%2f,b!)秒"
        speedLable.text="\(r)秒"
    }
    
    func transparentChanged()
    {
        transparentLable.text="\(Int(transparentSlider.value*100))%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view:UIView=UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 5))
        view.backgroundColor=UIColor.clear
        return view
    }
    
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

         Configure the cell...

        return cell
    }
    */
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */
    
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
