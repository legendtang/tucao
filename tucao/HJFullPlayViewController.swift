//
//  HJFullPlayViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/10.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import IJKMediaFrameworkWithSSL
import MagicMasterDanmaku
import Alamofire

class HJFullPlayViewController: UIViewController
{
    @IBOutlet weak var hidenDanmakuButton: UIButton!
    @IBOutlet weak var cancelButtonW: NSLayoutConstraint!
    @IBOutlet weak var bottombarbottom: NSLayoutConstraint!
    @IBOutlet weak var danmakuTextField: UITextField!
    @IBOutlet weak var toolTitle: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    public var Bigtitle:String?
    var timer:Timer?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var cacheSlider: UIProgressView!
    @IBOutlet weak var bottomToolView: UIView!
    @IBOutlet weak var topToolbar: UIView!
    var fulltapOne:UITapGestureRecognizer?
    public var playerView:UIView?;
    public var ijkplayer:IJKFFMoviePlayerController?;
    public var  Danmaku:MagicMasterDanmaku?
    public var tid:String?
    public var hid:String?
    public var beSelectVideoIndex:Int?
    public var isHiddenDanmaku:Bool?
    var AlamofireRequest:Request?
    
    override func viewDidDisappear(_ animated: Bool)
    {
        AlamofireRequest?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled=false
        toolTitle.text=Bigtitle
        self.navigationController?.navigationBar.isHidden=true
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target:self,selector:#selector(self.changePlayMessage),
                                     userInfo:nil,repeats:true)
        fulltapOne = UITapGestureRecognizer(target: self, action: #selector(self.hiddenPlayTool))
        fulltapOne?.numberOfTapsRequired = 1
        fulltapOne?.numberOfTouchesRequired = 1
        playerView?.addGestureRecognizer(fulltapOne!)
        cacheSlider.progress=Float((ijkplayer?.playableDuration)!/(ijkplayer?.duration)!)
        playSlider.value=Float((ijkplayer?.currentPlaybackTime)!)
        changeTimeLable(playtime: countTime(time: TimeInterval(playSlider.value)))
        if (ijkplayer?.isPlaying()==true)
        {
            playButton.setBackgroundImage(UIImage.init(named: "pause"), for: UIControl.State.normal)
        }
        else
        {
            playButton.setBackgroundImage(UIImage.init(named: "play"), for: UIControl.State.normal)
        }
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
    
    @IBAction func fireDanmaku(_ sender: Any)
    {
        view.endEditing(true)
        if danmakuTextField.text != ""
        {
            let message:String=danmakuTextField.text!
            danmakuTextField.text=""
            let url:URL = URL.init(string: "http://www.tucao.one/index.php?m=mukio&c=index&a=post&playerID=\(tid!)-\(hid!)-1-\(beSelectVideoIndex!)")!
            let parameter = ["stime":ijkplayer!.currentPlaybackTime,"color":16777215,"mode":1,"cid":"\(tid!)-\(hid!)-1-\(beSelectVideoIndex!)","message":message,"size":25,"user":"test",] as [String : Any]
            AlamofireRequest=AF.request(url, method: .post, parameters: parameter).responseString(completionHandler: {[weak self] response in
                switch response.result {
                    case .success:
                        self?.Danmaku?.insetDanmaku(message:message)
                    case .failure(let error):
                        print(error)
                    }
                }
            )
        }
    }

    
    @IBAction func playButtonAction(_ sender: Any)
    {
        if (ijkplayer?.isPlaying()==true)
        {
            ijkplayer?.pause()
            playButton.setBackgroundImage(UIImage.init(named: "play"), for: UIControl.State.normal)
            Danmaku?.pause()
        }
        else
        {
            playButton.setBackgroundImage(UIImage.init(named: "pause"), for: UIControl.State.normal)
            ijkplayer?.play()
            Danmaku?.resume()
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        playerView?.removeGestureRecognizer(fulltapOne!)
        timer=nil
    }
    
    override var shouldAutorotate: Bool
    {
        return true;
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return [UIInterfaceOrientationMask.landscapeRight,UIInterfaceOrientationMask.landscapeRight];
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        cancelButtonW.constant=0
        self.view.layoutIfNeeded()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        playSlider.maximumValue=Float((ijkplayer?.duration)!)
        playSlider.addTarget(self, action: #selector(self.startChangePlayTime), for: UIControl.Event.touchUpInside)
        playSlider.addTarget(self, action: #selector(self.endChangePlayTime), for: UIControl.Event.touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        if Danmaku?.view.isHidden == true
        {
            hidenDanmakuButton.alpha=0.4
        }
        else
        {
            hidenDanmakuButton.alpha=1.0
        }
    }
    
    @IBAction func hidenDanmaku(_ sender: Any)
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
    
    @objc func keyboardWillAppear(notification: NSNotification)
    {
        let keyboardinfo = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey]
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        bottombarbottom.constant=keyboardheight
        cancelButtonW.constant=46
    }
    
    @objc func keyboardWillDisappear(notification:NSNotification)
    {
        bottombarbottom.constant=0
        cancelButtonW.constant=0
    }
    
    @objc func startChangePlayTime()
    {
        timer?.invalidate()
        timer=nil
        timeLable.text=countTime(time: (TimeInterval(playSlider.value)))+"/"+countTime(time: (ijkplayer?.duration)!)
        changeTimeLable(playtime: countTime(time: TimeInterval(playSlider.value)))
    }
    
    
    @objc func endChangePlayTime()
    {
        ijkplayer?.currentPlaybackTime=Double(playSlider.value)
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target:self,selector:#selector(self.changePlayMessage),
                                     userInfo:nil,repeats:true)
    }

    @IBAction func backAction(_ sender: Any)
    {
         _ = self.navigationController?.popViewController(animated: false)
    }

    @IBAction func cancelAction(_ sender: Any)
    {
        view.endEditing(true)
    }
    
    @objc func changePlayMessage()
    {
        cacheSlider.progress=Float((ijkplayer?.playableDuration)!/(ijkplayer?.duration)!)
        playSlider.value=Float((ijkplayer?.currentPlaybackTime)!)
        changeTimeLable(playtime: countTime(time:(ijkplayer?.currentPlaybackTime)!))
    }
    
    @objc func hiddenPlayTool()
    {
        view.endEditing(true)
        bottomToolView.isHidden = !bottomToolView.isHidden
        topToolbar.isHidden=bottomToolView.isHidden
        playButton.isHidden=bottomToolView.isHidden
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
