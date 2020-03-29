//
//  HJsearchTableViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/22.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MJRefresh

class HJsearchTableViewController: UITableViewController,UISearchBarDelegate
{
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchbar: UISearchBar!
    var modelList:[HJVedioMessageModle]?
    var page:Int?=1
    var AlamofireRequest:Request?
    var key:String?
 
    
    override func viewDidDisappear(_ animated: Bool)
    {
        AlamofireRequest?.cancel()
    }
   
    override func viewDidLoad()
    {
        SegmentedControl.addTarget(self, action: #selector(self.changesort), for: UIControlEvents.valueChanged)
        key=""
        modelList=[]
        super.viewDidLoad()
        self.tableView.mj_footer=MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.getVideoList))
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func changesort()
    {
        AlamofireRequest?.cancel()
        page=1
        modelList?.removeAll()
        tableView.reloadData()
        tableView.mj_footer.beginRefreshing()
    }

    
    func getVideoList()
    {
        if key != ""{
            var order:String?
            switch SegmentedControl.selectedSegmentIndex
            {
            case 0:
                order="date"
                break
            case 1:
                order="mukio"
                break
            case 2:
                order="views"
                break
            default:
                break
            }
            let url:URL=URL.init(string: "http://www.tucao.tv/api_v2/search.php")!
            let parameter = ["apikey":"25tids8f1ew1821ed","pagesize":10,"page":page!,"order":order!,"q":key!,] as [String : Any]
            AlamofireRequest=Alamofire.request(url, method: .get, parameters: parameter).responseJSON(completionHandler: { [weak self] response in
                switch response.result.isSuccess
                {
                case true:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        if let dic = json["result"].arrayObject
                        {
                            let videoListArray = dic as NSArray?
                            for i in 0...(dic.count-1)
                            {
                                let modle:HJVedioMessageModle = HJVedioMessageModle()
                                let dics:NSDictionary = videoListArray![i] as! NSDictionary
                                modle.play = dics.object(forKey: "play") as! NSString?
                                modle.creat = dics.object(forKey: "creat") as! NSString?
                                modle.descriptions = dics.object(forKey: "description") as! NSString?
                                modle.mukio = dics.object(forKey: "mukio") as! NSString?
                                modle.thumb = dics.object(forKey: "thumb") as! NSString?
                                modle.title = dics.object(forKey: "title") as! NSString?
                                modle.video = dics.object(forKey: "video") as! [NSDictionary]?
                                modle.user = dics.object(forKey: "user") as! NSString?
                                modle.hid=dics.object(forKey: "hid") as! NSString?
                                modle.tid=dics.object(forKey: "typeid") as! NSString?
                                self?.modelList?.append(modle)
                            }
                            self?.page=(self?.page!)!+1
                            self?.tableView.mj_footer.endRefreshing()
                            self?.tableView.reloadData()
                        }
                        let count = json["total_count"].int
                        if  count! <= 0
                        {
                            self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                    }
                    break
                case false:
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    break
                }
            })
        }
        else
        {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    

    override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        AlamofireRequest?.cancel()
        modelList?.removeAll()
        key=searchbar.text
        page=1
        self.view.endEditing(true)
        self.tableView.reloadData()
        self.tableView.mj_footer.beginRefreshing()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (modelList?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:HJsearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "videolistCell", for: indexPath) as! HJsearchTableViewCell
        let modle:HJVedioMessageModle = modelList![indexPath.row]
        cell.paly.text=modle.play as String!
        cell.danmakulable.text=modle.mukio as String!
        let url:URL=URL.init(string: modle.thumb as! String)!
        cell.aimage.kf.setImage(with: url)
        cell.videotitle.text=modle.title as String!
        cell.user.text=modle.user as String!
        return cell
    }
 

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc:HJPlayViewController=segue.destination as! HJPlayViewController
        let index:Int=(tableView.indexPathForSelectedRow?.row)!
        let modle:HJVedioMessageModle=modelList![index]
        vc.videolist=modle.video
        vc.playTitle=modle.title as String?
        vc.thumb=modle.thumb as String?
        vc.descriptions=modle.descriptions as String?
        vc.mukio = modle.mukio  as String?
        vc.user=modle.user as String?
        vc.play=modle.play as String?
        vc.hid=modle.hid as String?
        vc.tid=modle.tid as String?
    }
 

}
