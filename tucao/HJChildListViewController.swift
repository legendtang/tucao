//
//  HJChildListViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/6.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import MJRefresh

class HJChildListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var contractButton: UIButton!
    @IBOutlet weak var classiftTableViewWIDTH: NSLayoutConstraint!
    var selectvideorow:Int?
    var isContract:Bool=false
    var beSelectIndex:Int?
    public var key:String?
    public var bigid:Int?
    public var id:Int?
    public var childClassifyarray:[NSDictionary]?
    @IBOutlet weak var classiftTableView: UITableView!
    @IBOutlet weak var VideoListTableView: UITableView!
    var videoListArray:NSArray?
    var VedioMessageModleList:[HJVedioMessageModle]?
    var pagelist:[Int]?
    var idlist:[Int]?
    var allmodlelist:[Any]?
    var AlamofireRequest:Request?
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        AlamofireRequest?.cancel()
    }
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor=UIColor.blue
        self.navigationController?.navigationBar.isTranslucent=false
        idlist=[]
        allmodlelist=[]
        pagelist=[]
        classiftTableView.tag=0
        VideoListTableView.tag=1
        VedioMessageModleList=[]
        if key != nil
        {
            let path = Bundle.main.path(forResource: "ClassifyList", ofType:"plist")
            let List:NSDictionary? = NSDictionary(contentsOfFile: path!)
            let childClassify:NSDictionary = (List?.object(forKey: key as Any) as! NSDictionary?)!
            childClassifyarray = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
        }
        
      
        
        var startIndex:Int?
        let vediolist:[HJVedioMessageModle]=[]
        allmodlelist?.append(vediolist)
        if bigid != nil
        {
            idlist?.append(bigid!)
        }
        else
        {
            idlist?.append(id!)
            startIndex=0
        }
        let page:Int?=2
        pagelist?.append(page!)


        for i in  0...(childClassifyarray?.count)!-1
        {
            let page:Int?=2
            pagelist?.append(page!)
            let dic:NSDictionary=childClassifyarray![i]
            let vediolist:[HJVedioMessageModle]=[]
            let ida:Int = dic.object(forKey: "id") as! Int
            idlist?.append(ida)
            allmodlelist?.append(vediolist)
            if startIndex == nil && self.id == ida
            {
                startIndex=i+1
            }
        }
        
        
        classiftTableView.selectRow(at: IndexPath.init(row: startIndex!, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
        beSelectIndex=startIndex
        SegmentedControl.addTarget(self, action: #selector(self.changesort), for: UIControl.Event.valueChanged)
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.getVedioList))
        VideoListTableView.mj_footer=footer
        footer.beginRefreshing()
    }
    
    @objc func changesort()
    {
        AlamofireRequest?.cancel()
        for i in 0...(allmodlelist?.count)!-1
        {
            let a:[HJVedioMessageModle]=[]
            allmodlelist?[i]=a
            pagelist?[i] = 2
        }
        self.VideoListTableView.reloadData()
        VideoListTableView.mj_footer?.beginRefreshing()
    }
    
    @IBAction func contractButtonAction(_ sender: Any)
    {
        if isContract==false
        {
            contractButton.setTitle("展开", for: UIControl.State.normal)
            classiftTableViewWIDTH.constant=0
        }
        else
        {
              contractButton.setTitle("收起", for: UIControl.State.normal)
            classiftTableViewWIDTH.constant=90
        }
        isContract = !isContract
        VideoListTableView.reloadData()
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
    
    
    @objc func getVedioList()
    {
        var order:String=""
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
        let parameter = ["apikey":"25tids8f1ew1821ed","tid":(idlist?[beSelectIndex!])! as Int,"page":(pagelist?[beSelectIndex!])! as Int,"pagesize":10,"order":order] as [String : Any]
        AlamofireRequest=AF.request("http://www.tucao.one/api_v2/list.php", method: .get, parameters: parameter).responseJSON(completionHandler:{ [weak self]  response in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                if let dic = json["result"].arrayObject
                {
                    self?.videoListArray = dic as NSArray?
                    if (self?.allmodlelist != nil)
                    {
                        var a:[HJVedioMessageModle]=self!.allmodlelist?[self!.beSelectIndex!] as! [HJVedioMessageModle]
                        for i in 0...(dic.count-1)
                        {
                            let modle:HJVedioMessageModle = HJVedioMessageModle()
                            let dics:NSDictionary = self!.videoListArray![i] as! NSDictionary
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
                            a.append(modle)
                        }
                        self!.allmodlelist?[self!.beSelectIndex!] = a
                        var b:Int=(self!.pagelist?[self!.beSelectIndex!])! as Int
                        b=b+1
                        self!.pagelist?[self!.beSelectIndex!]=b
                        self?.VideoListTableView.reloadData()
                        self?.VideoListTableView.mj_footer?.endRefreshing()
                        self?.classiftTableView.isUserInteractionEnabled=true
                    }
                }
            case .failure(let error):
                self?.VideoListTableView.mj_footer?.endRefreshing()
                print(error)
            }
        })
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag==0
        {
            return ((childClassifyarray?.count)!+1)
        }
        let a:[HJVedioMessageModle]=self.allmodlelist?[self.beSelectIndex!] as! [HJVedioMessageModle]
        return a.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag==0
        {
            let cell:HJClassifyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClassifyCell", for: indexPath) as! HJClassifyTableViewCell
            if indexPath.row==0
            {
                cell.title.text="全部"
            }
            else
            {
                let dic:NSDictionary=(childClassifyarray?[indexPath.row-1])!
                cell.title.text=dic.object(forKey: "name") as! String?
            }
            if indexPath.row==beSelectIndex
            {
                cell.title.textColor=UIColor.black
                cell.backgroundColor=UIColor.white
            }
            else
            {
                 cell.title.textColor=UIColor.white
                cell.backgroundColor=UIColor.init(red: 128.0/255.0, green: 0, blue: 1, alpha: 1)
            }
            cell.selectedBackgroundView=UIView.init(frame: cell.frame)
            cell.selectedBackgroundView?.backgroundColor=UIColor.white
            return cell
        }
        else
        {
            let cell: HJVideoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! HJVideoListTableViewCell
            if isContract==true
            {
                cell.playBottom.constant=8
                cell.playlablebottom.constant=8
                cell.mukioLeft.constant=100
                cell.titlelable.numberOfLines=2
            }
            else
            {
                cell.playBottom.constant=26.5
                cell.playlablebottom.constant=26.5
                cell.mukioLeft.constant=8
                cell.titlelable.numberOfLines=1
            }

            let a:[HJVedioMessageModle]=self.allmodlelist?[self.beSelectIndex!] as! [HJVedioMessageModle]
            let modle:HJVedioMessageModle=a[indexPath.row]
            cell.play.text=modle.play as String?
            cell.titlelable.text=modle.title as String?
            cell.user.text=modle.user as String?
            cell.mukio.text=modle.mukio as String?
            let url = URL(string: ((modle.thumb)! as NSString) as String)
            cell.aImage.kf.indicatorType = .activity
            cell.aImage.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))] , completionHandler: { (image, error, cacheType, imageUrl) in
            })
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.tag==0
        {
            if indexPath.row != beSelectIndex
            {
                AlamofireRequest?.cancel()
                AlamofireRequest=nil
                beSelectIndex=indexPath.row
                let a:[HJVedioMessageModle]=self.allmodlelist?[self.beSelectIndex!] as! [HJVedioMessageModle]
                if a.count==0
                {
                    VideoListTableView.mj_footer?.beginRefreshing()
                }
                VideoListTableView.reloadData()
                tableView.reloadData()
            }
        }
        else
        {
            selectvideorow=indexPath.row
            self.performSegue(withIdentifier: "toPlayView", sender: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if tableView.tag != 0
        {
            let cell: HJVideoListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as! HJVideoListTableViewCell
            cell.aImage.kf.cancelDownloadTask()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.tag==1
        {
            classiftTableView.isUserInteractionEnabled=false
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView.tag==1
        {
            classiftTableView.isUserInteractionEnabled=true
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        if scrollView.tag==1
        {
            classiftTableView.isUserInteractionEnabled=true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if scrollView.tag==1
        {
            classiftTableView.isUserInteractionEnabled=true
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc:HJPlayViewController=segue.destination as! HJPlayViewController
        let a:[HJVedioMessageModle]=self.allmodlelist?[self.beSelectIndex!] as! [HJVedioMessageModle]
        let modle:HJVedioMessageModle=a[selectvideorow!]
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
