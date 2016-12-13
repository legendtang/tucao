//
//  HJplaySetupTableViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/23.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJplaySetupTableViewController: UITableViewController
{
    @IBOutlet weak var sortencodeSlider: UISlider!
    @IBOutlet weak var videotoolboxSwitch: UISwitch!
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let  userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.set(videotoolboxSwitch.isOn, forKey: "videotoolbox")
        userDefaults.set(Int(20-sortencodeSlider.value), forKey: "sortencodevalue")
        userDefaults.synchronize()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let  userDefaults:UserDefaults = UserDefaults.standard
        let a:Bool? = userDefaults.bool(forKey: "videotoolbox")
        if a != nil
        {
            videotoolboxSwitch.setOn(a!, animated: true)
        }
        else
        {
            videotoolboxSwitch.setOn(false, animated: true)
        }
        
        let b:Int? = userDefaults.integer(forKey: "sortencodevalue")
        
        if b != nil
        {
            sortencodeSlider.value=20-Float(b!)
        }
        else
        {
            sortencodeSlider.value=15
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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

        // Configure the cell...

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
