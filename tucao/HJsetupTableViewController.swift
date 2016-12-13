//
//  HJsetupTableViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/23.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import Kingfisher

class HJsetupTableViewController: UITableViewController {

    @IBOutlet weak var Cachelable: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent=false
         self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "bule2"), for: UIBarMetrics.default)
        KingfisherManager.shared.cache.calculateDiskCacheSize { [weak self] size in
            self?.Cachelable.text="\(size/1024/1024)MB"
        }
    }

    @IBAction func back(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.section {
        case 2:
            let a:UIAlertController=UIAlertController.init(title: "清除缓存", message: "是否清除缓存？", preferredStyle: UIAlertControllerStyle.alert)
            let b:UIAlertAction=UIAlertAction.init(title: "是", style: UIAlertActionStyle.default, handler: { [weak self] (UIAlertAction) in
                KingfisherManager.shared.cache.clearDiskCache()
                self?.Cachelable.text="0MB"
            })
            let c:UIAlertAction=UIAlertAction.init(title: "否", style: UIAlertActionStyle.default, handler:nil)
            a.addAction(b)
            a.addAction(c)
            self.present(a, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20
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
