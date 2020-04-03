//
//  HJClassifyTableViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/7.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import Kingfisher
import SwiftyJSON


public enum ViewControllerClassify
{
    case newAnime
    case film
    case game
    case Music
    case animation
    case all
    case other
}

class HJClassifyTableViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    public var isreload:Bool?=false
    var bigid:Int?
    @IBOutlet weak var classifyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var classifyCollectionView: UICollectionView!
    public var classify:ViewControllerClassify?;
    var ClassifyList:NSDictionary?
    var childClassifyList:[NSDictionary]?
    var childClassifyDic:[NSDictionary]?
    var allmodlelistdic:NSMutableDictionary?
    var count:Int?=3
    var AlamofireRequest:Request?
    let  titleArray = ["动画","新番","音乐","游戏","影视","其他"]
    var AdvertisementViewController:HJAdvertisementViewController?

    override func viewDidDisappear(_ animated: Bool)
    {
        AlamofireRequest?.cancel()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    func setUp()
    {
        allmodlelistdic=NSMutableDictionary.init()
        self.tableView.rowHeight=UIScreen.main.bounds.size.width+170
        let path = Bundle.main.path(forResource: "ClassifyList", ofType:"plist")
        let List:NSDictionary? = NSDictionary(contentsOfFile: path!)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize=CGSize.init(width: UIScreen.main.bounds.width/4-1, height: classifyCollectionView.frame.size.height/2-1)
        layout.minimumLineSpacing=1
        layout.minimumInteritemSpacing=1
        
        switch self.classify!
        {
            
        case .all:
            ClassifyList=List?.object(forKey: "全部") as! NSDictionary?
            classifyViewHeightConstraint.constant=140
            break;
            
        case .animation:
            let childClassify:NSDictionary = (List?.object(forKey: "动画") as! NSDictionary?)!
            childClassifyList = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
            bigid=childClassify.object(forKey: "id") as! Int?
            break;
            
        case .newAnime:
            let childClassify:NSDictionary = (List?.object(forKey: "新番") as! NSDictionary?)!
            childClassifyList = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
            bigid=childClassify.object(forKey: "id") as! Int?
            break;
            
        case .Music:
            let childClassify:NSDictionary = (List?.object(forKey: "音乐") as! NSDictionary?)!
            childClassifyList = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
            bigid=childClassify.object(forKey: "id") as! Int?
            break;
            
        case .game:
            let childClassify:NSDictionary = (List?.object(forKey: "游戏") as! NSDictionary?)!
            childClassifyList = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
            bigid=childClassify.object(forKey: "id") as! Int?
            break;
            
        case .film:
            let childClassify:NSDictionary = (List?.object(forKey: "影视") as! NSDictionary?)!
            childClassifyList = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
            bigid=childClassify.object(forKey: "id") as! Int?
            break;
            
        case .other:
            let childClassify:NSDictionary = (List?.object(forKey: "其他") as! NSDictionary?)!
            childClassifyList = childClassify.object(forKey: "childClassify") as! [NSDictionary]?
            bigid=childClassify.object(forKey: "id") as! Int?
            break;
        }
        
        if classify != ViewControllerClassify.all
        {
            count=(childClassifyList?.count)!
            if  (childClassifyList?.count)!>4
            {
                classifyViewHeightConstraint.constant=140
            }
            else
            {
                classifyViewHeightConstraint.constant=70
            }
            self.tableView.tableHeaderView?.frame=CGRect.init(x: 0, y: 0, width: 0, height: classifyViewHeightConstraint.constant)
        }
        else
        {
            self.tableView.tableHeaderView?.frame=CGRect.init(x: 0, y: 0, width: 0, height: classifyViewHeightConstraint.constant+180)
            AdvertisementViewController=HJAdvertisementViewController()
            AdvertisementViewController?.view.frame=CGRect.init(x: 0, y: 0, width: (self.tableView.tableHeaderView?.frame.width)!, height:180)
            self.tableView.tableHeaderView?.addSubview((AdvertisementViewController?.view)!)
            self.addChild(AdvertisementViewController!)
            count=(ClassifyList?.count)!
        }
        
        
        
        
        classifyCollectionView.collectionViewLayout=layout;
        setUpNetworkVideoList()
    }
    
    
    func setUpNetworkVideoList()
    {
        for i in 0...count!-1
        {
            var url=""
            var parameter:Dictionary<String, Any>?
            if classify == ViewControllerClassify.all
            {
                url="http://www.tucao.one/api_v2/rank.php"
                parameter = ["apikey":"25tids8f1ew1821ed","tid":(ClassifyList?.object(forKey: titleArray[i]) as? Int)!,"date":1] as [String : Any]
            }
            else
            {
                let dic:NSDictionary = childClassifyList![i]
                url="http://www.tucao.one/api_v2/list.php"
                parameter = ["apikey":"25tids8f1ew1821ed","tid":(dic.object(forKey: "id") as? Int)!,"page":1,"pagesize":10,"order":"views"] as [String : Any]
            }
            AlamofireRequest=AF.request(url, method: .get, parameters: parameter).responseJSON(completionHandler: { [weak self] response in
//                 if self?.classify == ViewControllerClassify.all
//                 {print(response.request?.url)}
                switch response.result
                {
                case .success(let value):
                    let json = JSON(value)
                    var modlelist:[HJVedioMessageModle]=[]
                    if let dic = json["result"].dictionaryObject
                    {
                        let videoList = dic as NSDictionary?
                        let keyArray = videoList?.allKeys as NSArray?
                        for i in 0...(dic.count-1)
                        {
                            let modle:HJVedioMessageModle = HJVedioMessageModle()
                            let dics:NSDictionary = videoList?.object(forKey: keyArray?[i] as Any) as! NSDictionary
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
                            modlelist.append(modle)
                        }
                        self?.allmodlelistdic?.addEntries(from: [i:modlelist,])
                    }
                    else if let dic = json["result"].arrayObject
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
                            modlelist.append(modle)
                        }
                        self?.allmodlelistdic?.addEntries(from: [i:modlelist,])
                    }
                    if self?.classify == ViewControllerClassify.all
                    {
                        if  (self?.ClassifyList?.object(forKey:self?.titleArray[i] as Any) as! Int)  == 24
                        {
                            for i in 0...3
                            {
                                let image:UIImageView=(self?.AdvertisementViewController?.imagearray![i])!
                                image.isUserInteractionEnabled=true
                                let model:HJVedioMessageModle=modlelist[i]
                                let url:URL=URL.init(string: ((model.thumb)! as NSString) as String)!
                                let title = model.title! as String
                                self?.AdvertisementViewController?.titlearray![i]=title
                                image.kf.setImage(with: url)
                                var modellist:[HJVedioMessageModle]=(self?.AdvertisementViewController?.modellist)!
                                modellist.append(model)
                                self?.AdvertisementViewController?.modellist=modellist
                            }
                        }
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    
    func setClassifyIcon(index:Int,classify:ViewControllerClassify) -> KFCrossPlatformImage
    {
        switch self.classify!
        {
        case .all:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "animation")!
            case 1:
                return KFCrossPlatformImage.init(named: "newfan")!
            case 2:
                 return KFCrossPlatformImage.init(named: "music")!
            case 3:
                 return KFCrossPlatformImage.init(named: "game")!
            case 4:
                 return KFCrossPlatformImage.init(named: "television")!
            case 5:
                 return KFCrossPlatformImage.init(named: "other")!
            default:
                break;
            }
            break;
            
        case .animation:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "mad")!
            case 1:
                return KFCrossPlatformImage.init(named: "mmd")!
            case 2:
                return KFCrossPlatformImage.init(named: "dub")!
            case 3:
                return KFCrossPlatformImage.init(named: "other")!
            default:
                break;
            }

            break;
            
        case .newAnime:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "newfan")!
            case 1:
                return KFCrossPlatformImage.init(named: "chinese")!
            case 2:
                return KFCrossPlatformImage.init(named: "ova")!
            case 3:
                return KFCrossPlatformImage.init(named: "finshed")!
            default:
                break;
            }

            break;
            
        case .Music:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "acgmusic")!
            case 1:
                return KFCrossPlatformImage.init(named: "sing")!
            case 2:
                return KFCrossPlatformImage.init(named: "dance")!
            case 3:
                return KFCrossPlatformImage.init(named: "vocaloid")!
            case 4:
                return KFCrossPlatformImage.init(named: "instrument")!
            case 5:
                return KFCrossPlatformImage.init(named: "music")!
            case 6:
                return KFCrossPlatformImage.init(named: "live")!
            default:
                break;
            }

            break;
            
        case .game:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "gmv")!
            case 1:
                return KFCrossPlatformImage.init(named: "networkgame")!
            case 2:
                return KFCrossPlatformImage.init(named: "sologame")!
            case 3:
                return KFCrossPlatformImage.init(named: "esports")!
            case 4:
                return KFCrossPlatformImage.init(named: "gameboy")!
            default:
                break;
            }

            break;
            
        case .film:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "tv")!
            case 1:
                return KFCrossPlatformImage.init(named: "film")!
            case 2:
                return KFCrossPlatformImage.init(named: "televisionamuse")!
            case 3:
                return KFCrossPlatformImage.init(named: "finshed")!
            default:
                break;
            }

            break;
            
        case .other:
            switch index
            {
            case 0:
                return KFCrossPlatformImage.init(named: "xiwenlejian")!
            case 1:
                return KFCrossPlatformImage.init(named: "otomad")!
            case 2:
                return KFCrossPlatformImage.init(named: "technology")!
            case 3:
                return KFCrossPlatformImage.init(named: "sports")!
            case 4:
                return KFCrossPlatformImage.init(named: "military")!
            case 5:
                return KFCrossPlatformImage.init(named: "pet")!
            default:
                break;
            }
            break;
        }
        return KFCrossPlatformImage.init()
    }
    
    
    // MARK: -  collectionView data source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 0
        {
            let cell :HJClassifyCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "classifyCell", for: indexPath) as! HJClassifyCellCollectionViewCell
            if classify == ViewControllerClassify.all
            {
                cell.title.text = titleArray[indexPath.row]
                cell.id = ClassifyList?.object(forKey: titleArray[indexPath.row]) as! Int;
            }
            else
            {
                let dic:NSDictionary = childClassifyList![indexPath.row]
                cell.title.text = dic.object(forKey: "name") as! String?
                cell.id = dic.object(forKey: "id") as! Int
            }
            cell.image.image=setClassifyIcon(index: indexPath.row, classify: classify!)
            return cell
        }
        else
        {
            let cell :HJMainPageShowVideoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HJMainPageShowVideoCollectionViewCell", for: indexPath) as! HJMainPageShowVideoCollectionViewCell
            cell.layer.masksToBounds = true;
            cell.layer.cornerRadius = 7.0;
            cell.layer.borderWidth = 1;
            cell.layer.borderColor=UIColor.blue.cgColor
//            if (allmodlelistdic?.count)! >= count! && collectionView.tag-20 >= 0
            if allmodlelistdic?.object(forKey: collectionView.tag-20) != nil
            {
                let  a:[Any] =  allmodlelistdic?.object(forKey: collectionView.tag-20) as! [Any]
                let modle:HJVedioMessageModle=a[indexPath.row] as! HJVedioMessageModle
                cell.videoTitle.text = modle.title as String?
                cell.playCount.text="播放:\((modle.play)! as NSString)"
                cell.danmaku.text = "弹幕:\((modle.mukio)! as NSString)"
                let url = URL(string: ((modle.thumb)! as NSString) as String)
                cell.image.kf.indicatorType = .activity
                cell.image.kf.setImage(with: url, placeholder: nil, options: [.forceTransition,.transition(.fade(0.3))] , completionHandler: { (image, error, cacheType, imageUrl) in
                })
                cell.isUserInteractionEnabled=true
            }
            else
            {
                cell.videoTitle.text = "加载中"
                cell.playCount.text="播放:???"
                cell.danmaku.text = "弹幕:???"
                cell.image.image=nil
                cell.isUserInteractionEnabled=false
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView.tag==0
        {
            if classify == ViewControllerClassify.all
            {
                return (ClassifyList?.count)!;
            }
            else
            {
                return (childClassifyList?.count)!;
            }
        }
        else
        {
            return 4
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView.tag != 0 && (allmodlelistdic?.count)! > 0
        {
            let sm:UIStoryboard=UIStoryboard.init(name: "Main", bundle: nil)
            let vc:HJPlayViewController = sm.instantiateViewController(withIdentifier: "HJPlayViewController") as! HJPlayViewController
            let  a:[Any] =  self.allmodlelistdic?.object(forKey: collectionView.tag-20) as! [Any]
            let modle:HJVedioMessageModle=a[indexPath.row] as! HJVedioMessageModle
            vc.videolist=modle.video
            vc.playTitle=modle.title as String?
            vc.thumb=modle.thumb as String?
            vc.descriptions=modle.descriptions as String?
            vc.mukio = modle.mukio  as String?
            vc.user=modle.user as String?
            vc.play=modle.play as String?
            vc.hid=modle.hid as String?
            vc.tid=modle.tid as String?
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        if classify == ViewControllerClassify.all
        {
            return 6
        }
        else
        {
            return (childClassifyList?.count)!
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HJMainPageShowVideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HJMainPageShowVideoTableViewCell" ,for:indexPath) as! HJMainPageShowVideoTableViewCell
        if classify==ViewControllerClassify.all
        {
            cell.titlelable.text=titleArray[indexPath.row]
        }
        else
        {
            let dic:NSDictionary = childClassifyList![indexPath.row]
            cell.titlelable.text=dic.object(forKey: "name") as! String?
        }
        cell.scrollView.tag=indexPath.row+20
        cell.scrollView.reloadData()
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
        let  cell:HJClassifyCellCollectionViewCell = classifyCollectionView.cellForItem(at: (classifyCollectionView.indexPathsForSelectedItems?.first)!) as! HJClassifyCellCollectionViewCell
        let VC:HJChildListViewController = segue.destination as! HJChildListViewController
        VC.id=cell.id
        if classify==ViewControllerClassify.all
        {
            VC.key=cell.title.text
        }
        else
        {
            VC.childClassifyarray=childClassifyList
            VC.bigid=bigid
        }
    }
}
