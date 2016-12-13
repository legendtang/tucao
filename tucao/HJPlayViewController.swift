//
//  HJPlayViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/6.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import IJKMediaFramework
import MagicMasterDanmaku
import  Alamofire
import SwiftyJSON
import Kingfisher


class HJPlayViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,MagicMasterDanmakudelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
    @IBOutlet weak var hidenDanmakuButton: UIButton!
    @IBOutlet weak var danmakuTextField: UITextField!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var fengjiLableH: NSLayoutConstraint!
    @IBOutlet weak var contractButton: UIButton!
    @IBOutlet weak var contractButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var videoListCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoListCollectionView: UICollectionView!
    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var descriptionlable: UILabel!
    @IBOutlet weak var mukioLable: UILabel!
    @IBOutlet weak var playLable: UILabel!
    @IBOutlet weak var userlable: UILabel!
    @IBOutlet weak var toolbarHeight: NSLayoutConstraint!
    @IBOutlet weak var titlelable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var playToolBar: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var cacheSlider: UIProgressView!
    public var playTitle: String?
    public var play:String?
    public var mukio:String?
    public var creat:String?
    public var user:String?
    public var descriptions:String?
    public var hid:String?
    public var videolist:[NSDictionary]?
    public var thumb:String?
    var commentDataList:[HJCommentModel]?
    var beSelectVideoIndex:Int?=0
    var timer:Timer?
    var ijkplayer:IJKFFMoviePlayerController?;
    var playerView:UIView?;
    var tapOne:UITapGestureRecognizer?
    var loadMessage:UILabel?
    var videoURL:URL?
    var Danmaku:MagicMasterDanmaku?
    var commentPage:Int? = 1
    var tid:String?
    var isHiddenDanmaku:Bool?=false
    var ActivityIndicatorView:UIActivityIndicatorView?
    var AlamofirefireDanmakuRequest:Request?
    var AlamofireCommentRequest:Request?
    var sortencodevalue:Int=5
    var isvideotoolbox:Bool=false
    var maxDanmakuCount:Int?=30
    var DanmakuSpeed:Double?=5
    var DanmakuTransparent:Float?=1
    
    

    @IBAction func backACTION(_ sender: Any)
    {
        _ =  self.navigationController?.popViewController(animated: true)
        ijkplayer?.shutdown()
        timer?.invalidate()
        Danmaku?.shutdown()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        AlamofireCommentRequest?.cancel()
        AlamofirefireDanmakuRequest?.cancel()
        timer=nil
        playerView?.removeGestureRecognizer(tapOne!)
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden=false
        playerView?.frame=CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:playView.frame.size.height);
        Danmaku?.changeViewFrame(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (playerView?.frame.size.height)!))
        playView.layoutIfNeeded()
        ActivityIndicatorView?.frame=CGRect.init(x: UIScreen.main.bounds.width/2-15, y: playView.frame.size.height/2-15, width: 30, height: 30)
        ijkplayer?.view.addSubview(ActivityIndicatorView!)
        ActivityIndicatorView?.hidesWhenStopped=true
        playerView?.addGestureRecognizer(tapOne!)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target:self,selector:#selector(self.changePlayMessage),
                                     userInfo:nil,repeats:true)
        if(ijkplayer?.isPreparedToPlay==true)
        {
            self.playView.insertSubview(playerView!, at: 1);
        }
        if (ijkplayer?.isPlaying()==true)
        {
            playButton.setBackgroundImage(UIImage.init(named: "pause"), for: UIControlState.normal)
        }
        else
        {
            playButton.setBackgroundImage(UIImage.init(named: "play"), for: UIControlState.normal)
        }
        
        if Danmaku != nil
        {
            isHiddenDanmaku =  (Danmaku?.view.isHidden)!
            if Danmaku?.view.isHidden == true
            {
                hidenDanmakuButton.alpha=0.4
            }
            else
            {
                hidenDanmakuButton.alpha=1.0
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let  userDefaults:UserDefaults = UserDefaults.standard
        isvideotoolbox = userDefaults.bool(forKey: "videotoolbox")
        sortencodevalue = userDefaults.integer(forKey: "sortencodevalue")
        maxDanmakuCount =  userDefaults.integer(forKey: "maxDanmakuCount")
        if maxDanmakuCount == 80
        {
            maxDanmakuCount = 1000
        }
        DanmakuSpeed = userDefaults.double(forKey: "DanmakuSpeed")
        DanmakuTransparent =  userDefaults.float(forKey: "DanmakuTransparent")
        commentDataList=[]
        loadMessage=UILabel.init()
        let dic:NSDictionary=videolist![0]
        ActivityIndicatorView =  UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        if dic.object(forKey: "vid") == nil
        {
            _ =  self.navigationController?.popViewController(animated: true)
            return
        }
        commentTableView.mj_footer=MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.getComment))
        commentTableView.estimatedRowHeight=100
        commentTableView.rowHeight = UITableViewAutomaticDimension
        self.title=playTitle
        NotificationCenter.default.addObserver(self, selector: #selector(self.setDanmakuStart), name:  NSNotification.Name.init(rawValue: "setDanmakuStart"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.IJKMPMoviePlayerPlaybackStateDidChange), name:  NSNotification.Name.init(rawValue: "IJKMPMoviePlayerPlaybackStateDidChangeNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.IJKMPMoviePlayerLoadStateDidChange), name:  NSNotification.Name.init(rawValue: "IJKMPMoviePlayerLoadStateDidChangeNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finshedDanmaku(notification:)), name:  NSNotification.Name.init(rawValue: "setDanmakuFinshed"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.IJKMPMoviePlayerPlaybackDidFinish), name:  NSNotification.Name.init(rawValue: "IJKMPMoviePlayerPlaybackDidFinishNotification"), object: nil)
        
        setURL(vid: dic.object(forKey: "vid") as! String)
        playLable.text="播放:"+play!
        userlable.text="up:"+user!
        mukioLable.text="弹幕:"+mukio!
        descriptionlable.text=descriptions as String?
        titlelable.text=playTitle
        tapOne = UITapGestureRecognizer(target: self, action: #selector(self.hiddenPlayTool))
        tapOne?.numberOfTapsRequired = 1
        tapOne?.numberOfTouchesRequired = 1
        let options:IJKFFOptions = IJKFFOptions.byDefault()
        if isvideotoolbox == true
        {
            options.setPlayerOptionIntValue(1, forKey: "videotoolbox")
        }
        else
        {
            options.setPlayerOptionIntValue(Int64(sortencodevalue), forKey: "framedrop")
        }
        ijkplayer=IJKFFMoviePlayerController.init(contentURL: videoURL, with:options)
        playerView=ijkplayer?.view
        playSlider.value=0
        playButton.isHidden=false
        playToolBar.isHidden=false
        playSlider.isHidden=true
        cacheSlider.isHidden=true
        timeLable.isHidden=true
        fullButton.isHidden=true
        playSlider.addTarget(self, action: #selector(self.startChangePlayTime), for: UIControlEvents.touchDragInside)
        playSlider.addTarget(self, action: #selector(self.endChangePlayTime), for: UIControlEvents.touchUpInside)
        toolbarHeight.constant=0
        let a:UIImageView=UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:playView.frame.size.height))
        let imageurl=URL.init(string: thumb!)
        a.kf.setImage(with: imageurl, placeholder: nil, options: [.forceTransition,.transition(.fade(0.3))], completionHandler:{ (image, error, cacheType, imageUrl) in
        })
        loadMessage?.frame=CGRect.init(x: 2, y: playView.frame.size.height-22, width: 0, height: 0)
        self.playView.insertSubview(a, at: 0)
        a.addSubview(loadMessage!)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize=CGSize.init(width: UIScreen.main.bounds.width/3-5, height: 30)
        layout.minimumLineSpacing=2
        layout.minimumInteritemSpacing=1
        videoListCollectionView.collectionViewLayout=layout
        self.videoListCollectionView.layoutIfNeeded()
        beSelectVideoIndex=0
        if (videolist?.count)! <= 1
        {
             self.videoListCollectionViewHeight.constant=0
            fengjiLableH.constant=0
        }
        else
        {
             self.videoListCollectionViewHeight.constant=30
        }
        if (videolist?.count)! <= 3
        {
            self.contractButtonHeight.constant = 0
            contractButton.isHidden=true
        }
    }
    
    @IBAction func hiddenDanmaku(_ sender: Any)
    {
        isHiddenDanmaku = !isHiddenDanmaku!
        Danmaku?.view.isHidden=isHiddenDanmaku!
        if Danmaku?.view.isHidden == true
        {
            hidenDanmakuButton.alpha=0.4
        }
        else
        {
            hidenDanmakuButton.alpha=1.0
        }
    }
    
    func setDanmakuStart()
    {

    }

    
    func IJKMPMoviePlayerPlaybackDidFinish()
    {
        if ijkplayer?.bufferingProgress == 0
        {
            loadMessage?.text = "加载视频失败= o ="
            loadMessage?.sizeToFit()
        }
        else
        {
            playButton.setBackgroundImage(UIImage.init(named: "play"), for: UIControlState.normal)
        }
    }
    
    func getComment()
    {
        let parameter = ["tid":tid!,"page":commentPage!,"id":hid!] as [String : Any]
        AlamofireCommentRequest=Alamofire.request("https://www.biliplus.com/tucao/review.php", method: .get, parameters: parameter).responseJSON(completionHandler:
            {[weak self]  response in
                switch response.result.isSuccess
                {
                case true:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        if let array = json["data"].arrayObject
                        {
                            if array.count>0
                            {
                                for i in 0...array.count-1
                                {
                                    let model:HJCommentModel = HJCommentModel()
                                    let dic:NSDictionary = array[i] as! NSDictionary
                                    model.avatar=dic.object(forKey: "face") as! String!
                                    model.comment=dic.object(forKey: "content") as! String!
                                    model.username=dic.object(forKey: "uname") as! String!
                                    self?.commentDataList?.append(model)
                                }
                                self?.commentPage=(self?.commentPage)!+1
                                self?.commentTableView.reloadData()
                                self?.commentTableView.mj_footer.endRefreshing()
                            }
                            else
                            {
                                 self?.commentTableView.mj_footer.endRefreshingWithNoMoreData()
                            }
                        }
                    }
                
                case false:
                    self?.commentTableView.mj_footer.endRefreshing()
                    print("请求失败")
                }
        })

    }
    
    func startChangePlayTime()
    {
        timer?.invalidate()
        timer=nil
        timeLable.text=countTime(time: (TimeInterval(playSlider.value)))+"/"+countTime(time: (ijkplayer?.duration)!)
        changeTimeLable(playtime: countTime(time: TimeInterval(playSlider.value)))
    }
    
    
    func endChangePlayTime()
    {
        ijkplayer?.currentPlaybackTime=Double(playSlider.value)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target:self,selector:#selector(self.changePlayMessage),
                                     userInfo:nil,repeats:true)
        if (ijkplayer?.isPlaying()==false)
        {
              ijkplayer?.play()
        }
    }
    

    @IBAction func fullscreenAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toFullView", sender: nil)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
    
    func hiddenPlayTool()
    {
        playButton.isHidden = !playButton.isHidden
        playToolBar.isHidden=playButton.isHidden
    }
    
    @IBAction func contractButtonAction(_ sender: Any)
    {

        if self.videoListCollectionViewHeight.constant != self.videoListCollectionView.contentSize.height
        {
            self.videoListCollectionViewHeight.constant=self.videoListCollectionView.contentSize.height
            self.scrollHeight.constant+=self.videoListCollectionView.contentSize.height
            contractButton.setTitle("收起", for: UIControlState.normal)
        }
        else
        {
            self.videoListCollectionViewHeight.constant=30
            contractButton.setTitle("展开", for: UIControlState.normal)
            self.scrollHeight.constant=700
        }
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func playButtonAction(_ sender: Any)
    {
        if (ijkplayer != nil)
        {
            if(ijkplayer?.isPreparedToPlay==false)
            {
                let imageview:UIImageView =  self.playView.subviews[0] as! UIImageView
                imageview.image=UIImage.init(named: "loading")
                let url:String="http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=11-\(hid! as String)-1-\(beSelectVideoIndex!)&r=253"
                Danmaku=MagicMasterDanmaku.init(UrlString: url)
                Danmaku?.delegate=self
                Danmaku?.view.isHidden=isHiddenDanmaku!
                if Danmaku?.view.isHidden == true
                {
                    hidenDanmakuButton.alpha=0.4
                }
                else
                {
                    hidenDanmakuButton.alpha=1.0
                }
                Danmaku?.danmakuSpeed=DanmakuSpeed
                Danmaku?.maxDanmakuCount=maxDanmakuCount
                Danmaku?.view.alpha=CGFloat(DanmakuTransparent!)
                hidenDanmakuButton.isUserInteractionEnabled=false
                playButton.isUserInteractionEnabled=false
                playSlider.isUserInteractionEnabled=false
                fullButton.isUserInteractionEnabled=false
                playButton.isHidden = true
                playSlider.isHidden=false
                cacheSlider.isHidden=false
                timeLable.isHidden=false
                fullButton.isHidden=false
                playToolBar.isHidden=playButton.isHidden
                playButton.setBackgroundImage(UIImage.init(named: "pause"), for: UIControlState.normal)
                playSlider.minimumValue=0
                toolbarHeight.constant=36
                Danmaku?.view.frame=CGRect.init(x: 0, y: 0, width: (playerView?.frame.size.width)!, height: (playerView?.frame.size.height)!)
                self.playView.insertSubview(playerView!, at: 1);
                self.playerView?.addSubview((Danmaku?.view)!)
                return
            }
            if (ijkplayer?.isPlaying()==true)
            {
                ijkplayer?.pause()
                playButton.setBackgroundImage(UIImage.init(named: "play"), for: UIControlState.normal)
                Danmaku?.pause()
            }
            else
            {
                //            if ijkplayer?.currentPlaybackTime == ijkplayer?.duration
                //            {
                //                ijkplayer?.currentPlaybackTime=0
                //            }
                playButton.setBackgroundImage(UIImage.init(named: "pause"), for: UIControlState.normal)
                ijkplayer?.play()
                playButton.isHidden = true
                playToolBar.isHidden=playButton.isHidden
                Danmaku?.resume()
            }
        }
        else
        {
            let imageview:UIImageView =  self.playView.subviews[0] as! UIImageView
            playButton.isHidden = true
            imageview.image=UIImage.init(named: "loading")
            loadMessage?.text = "加载视频失败= o ="
            loadMessage?.sizeToFit()
        }
    }
    
    func finshedDanmaku(notification:Notification)
    {
//        var message:String=(loadMessage?.text)!
//        message.append("弹幕加载完成\n")
//        message.append( "加载视频\n")
//        loadMessage?.text=message
//        loadMessage?.sizeToFit()
//        loadMessage?.layoutIfNeeded()
        ijkplayer?.prepareToPlay()
    }
    
    
    
    @IBAction func fireDanmaku(_ sender: Any)
    {
        self.view.endEditing(true)
        if danmakuTextField.text != ""
        {
            let message:String=danmakuTextField.text!
            danmakuTextField.text=""
            let url:URL = URL.init(string: "http://www.tucao.tv/index.php?m=mukio&c=index&a=post&playerID=\(tid!)-\(hid!)-1-\(beSelectVideoIndex!)")!
            let parameter = ["stime":ijkplayer!.currentPlaybackTime,"color":16777215,"mode":1,"cid":"\(tid!)-\(hid!)-1-\(beSelectVideoIndex!)","message":message,"size":25,"user":"test",] as [String : Any]
            AlamofirefireDanmakuRequest=Alamofire.request(url, method: .post, parameters: parameter).responseString(completionHandler: {[weak self] response in
                if response.result.value! == "ok"
                {
                    self?.Danmaku?.insetDanmaku(message:message)
                }
            })
        }
    }
    
    func changePlayMessage()
    {
        if (ijkplayer != nil)
        {
            if(playSlider.value<=0)
            {
                playSlider.maximumValue=Float((ijkplayer?.duration)!)
            }
            changeTimeLable(playtime: countTime(time: (ijkplayer?.currentPlaybackTime)!))
            cacheSlider.setProgress(Float((ijkplayer?.playableDuration)!/(ijkplayer?.duration)!), animated: false)
            playSlider.setValue(Float((ijkplayer?.currentPlaybackTime)!), animated: true)
        }
    }
    
    func IJKMPMoviePlayerLoadStateDidChange()
    {
        if (ijkplayer?.loadState.rawValue==4)
        {
            ActivityIndicatorView?.startAnimating()
        }
        else
        {
            Danmaku?.fire()
            ActivityIndicatorView?.stopAnimating()
            hidenDanmakuButton.isUserInteractionEnabled=true
            playButton.isUserInteractionEnabled=true
            playSlider.isUserInteractionEnabled=true
            fullButton.isUserInteractionEnabled=true
        }

//        print("dfgdfgdfgdfgdfg")
//        print(ijkplayer?.loadState.rawValue)
//        if ijkplayer?.loadState ==  IJKMPMovieLoadState.playthroughOK
//        {
//            print("11111111")
//        }
//        if ijkplayer?.loadState ==  IJKMPMovieLoadState.playable
//        {
//            print("222222222")
//        }
//        if ijkplayer?.loadState ==  IJKMPMovieLoadState.stalled
//        {
//            print("3333333")
//        }
        
    }
    
    func changeTimeLable(playtime:String)
    {
        timeLable.text=playtime+"/"+countTime(time: (ijkplayer?.duration)!)
    }
    
    
    func countTime(time:TimeInterval) -> String
    {
        if(time/60<60)
        {
            let second = Int(time)%60
            let minute:Int=Int(time/60)
            return "\(setTimeFormat(time: minute)):\(setTimeFormat(time: second))"
        }
        else
        {
            let hour:Int = Int(time/60)/60
            let minute:Int=Int(time/60)%60
            let second:Int = Int(time) - Int(minute*60) - Int(60*60*hour)
            return "\(setTimeFormat(time: hour)):\(setTimeFormat(time: minute)):\(setTimeFormat(time: second))"
        }
    }
    
    
    func setTimeFormat(time:Int) -> String
    {
        if(time<10)
        {
            return "0\(time)"
        }
        return "\(time)"
    }
    
    
    func getPlayTime()->Int
    {
        if self.ijkplayer != nil
        {
            return Int((ijkplayer?.currentPlaybackTime)!)
        }
        return 0
    }
    
    func setURL(vid:String)
    {
        videoURL=URL(string:"http://api.tucao.tv/api/down/"+vid)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if beSelectVideoIndex != indexPath.row
        {
            loadMessage?.text=""
            loadMessage?.sizeToFit()
            ijkplayer?.shutdown()
            ijkplayer=nil
            let dic:NSDictionary = videolist![indexPath.row]
            setURL(vid: dic.object(forKey: "vid") as! String )
            let options:IJKFFOptions = IJKFFOptions.byDefault()
            if isvideotoolbox == true
            {
                options.setPlayerOptionIntValue(1, forKey: "videotoolbox")
            }
            else
            {
                options.setPlayerOptionIntValue(Int64(sortencodevalue), forKey: "framedrop")
            }
            ijkplayer=IJKFFMoviePlayerController.init(contentURL: videoURL, with:options)
            playerView?.removeFromSuperview()
            hidenDanmakuButton.isUserInteractionEnabled=false
            playButton.isUserInteractionEnabled=false
            playSlider.isUserInteractionEnabled=false
            fullButton.isUserInteractionEnabled=false
            playButton.isHidden = true
            playSlider.isHidden=false
            cacheSlider.isHidden=false
            timeLable.isHidden=false
            fullButton.isHidden=false
            playToolBar.isHidden=playButton.isHidden
            playButton.setBackgroundImage(UIImage.init(named: "pause"), for: UIControlState.normal)
            playSlider.minimumValue=0
            toolbarHeight.constant=36
            beSelectVideoIndex=indexPath.row
            if (ijkplayer != nil)
            {
                playerView=ijkplayer?.view
                ijkplayer?.prepareToPlay()
                playerView?.frame=CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height:playView.frame.size.height);
                playerView?.addGestureRecognizer(tapOne!)
                self.playView.insertSubview(playerView!, at: 1);
                let url:String="http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=11-\(hid! as String)-1-\(beSelectVideoIndex!)&r=253"
                Danmaku=MagicMasterDanmaku.init(UrlString: url)
                Danmaku?.delegate=self
                Danmaku?.view.isHidden=isHiddenDanmaku!
                Danmaku?.danmakuSpeed=DanmakuSpeed
                Danmaku?.maxDanmakuCount=maxDanmakuCount
                Danmaku?.view.alpha=CGFloat(DanmakuTransparent!)
                if Danmaku?.view.isHidden == true
                {
                    hidenDanmakuButton.alpha=0.4
                }
                else
                {
                    hidenDanmakuButton.alpha=1.0
                }
                Danmaku?.view.frame=CGRect.init(x: 0, y: 0, width: (playerView?.frame.size.width)!, height: (playerView?.frame.size.height)!)
                ActivityIndicatorView=nil
                ActivityIndicatorView =  UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
                ActivityIndicatorView?.frame=CGRect.init(x: playView.frame.size.width/2-15, y: playView.frame.size.height/2-15, width: 30, height: 30)
                ActivityIndicatorView?.hidesWhenStopped=true
                ijkplayer?.view.addSubview(ActivityIndicatorView!)
                self.playerView?.addSubview((Danmaku?.view)!)
            }
            else
            {
                loadMessage?.text = "加载视频失败= o ="
                loadMessage?.sizeToFit()
            }
            collectionView.reloadData()
        }
    }

    func IJKMPMoviePlayerPlaybackStateDidChange()
    {
        if ijkplayer?.playbackState != IJKMPMoviePlaybackState.playing
        {
            Danmaku?.pause()
        }
        else
        {
            Danmaku?.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (videolist?.count)!
    }
    

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:HJvideoListCollectionViewCell=collectionView.dequeueReusableCell(withReuseIdentifier: "HJvideoListCollectionViewCell", for: indexPath) as! HJvideoListCollectionViewCell
        cell.layer.masksToBounds = true;
        cell.layer.cornerRadius = 6.0;
        let dic:NSDictionary=videolist![indexPath.row]
        cell.titleLable.text=dic.object(forKey: "title") as! String?
        if (indexPath.row==beSelectVideoIndex)
        {
            cell.backgroundColor=UIColor.init(red: 64.0/255.0, green: 0, blue: 128.0/255.0, alpha: 1)
        }
        else
        {
            cell.backgroundColor=UIColor.init(red: 0, green: 128.0/255.0, blue: 1, alpha: 1)
        }
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - TableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (commentDataList?.count)!
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:HJCommentTableViewCell=tableView.dequeueReusableCell(withIdentifier: "HJCommentTableViewCell", for: indexPath) as! HJCommentTableViewCell
        if (commentDataList?.count)!>indexPath.row
        {
            let model:HJCommentModel = commentDataList![indexPath.row]
            cell.username.text=model.username
            cell.comment.text=model.comment
            let url = URL(string: ((model.avatar)! as NSString) as String)
            cell.avatar.layer.cornerRadius=cell.avatar.frame.width/2
            cell.avatar.layer.masksToBounds=true
            cell.avatar.kf.indicatorType = .activity
            cell.avatar.kf.setImage(with: url)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cell:HJCommentTableViewCell=tableView.dequeueReusableCell(withIdentifier: "HJCommentTableViewCell", for: indexPath) as! HJCommentTableViewCell
        cell.avatar.kf.cancelDownloadTask()
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "评论"
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toFullView"
        {
            let vc:HJFullPlayViewController = segue.destination as! HJFullPlayViewController
            vc.ijkplayer=ijkplayer
            vc.playerView=playerView
            vc.playerView?.frame=CGRect.init(x: 0, y: UIScreen.main.bounds.width/2-(UIScreen.main.bounds.height*9/16/2), width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.height*9/16)
            ActivityIndicatorView?.frame=CGRect.init(x: UIScreen.main.bounds.height/2-25, y: UIScreen.main.bounds.width/2-25, width: 50, height: 50)
            Danmaku?.changeViewFrame(frame: CGRect.init(x: 0, y: 0, width: (playerView?.frame.size.width)!, height: (playerView?.frame.size.height)!))
            vc.view.insertSubview(vc.playerView!, at: 0)
            vc.Bigtitle=playTitle
            vc.Danmaku=Danmaku
            vc.tid=tid
            vc.hid=hid
            vc.beSelectVideoIndex=beSelectVideoIndex
        }
        
    }
}
