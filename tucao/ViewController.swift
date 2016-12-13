//
//  ViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/4.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import IJKMediaFramework



class ViewController: UIViewController,XMLParserDelegate
{
    @IBOutlet weak var fdfdf: UIView!
    var ijkplayer:IJKFFMoviePlayerController?;
    var playerView:UIView?;
    var  player : AVPlayer?=nil;
    var playerLayer:AVPlayerLayer? = nil;
    var parser:XMLParser?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.portrait;
    }

    override func viewDidAppear(_ animated: Bool)
    {
            }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let videoURL = URL(string:"http://cn-gdfs4-dx-v-06.acgvideo.com/vg3/9/45/11347322-1-hd.mp4?expires=1478596200&ssig=-JitxXNxK8oxV7Ldulpbqw&oi=3074096427&rate=3100000")
////        player = AVPlayer(url: videoURL!)
////        playerLayer = AVPlayerLayer(player: player)
////        playerLayer?.frame = self.view.bounds
////        player?.play()
//        
//        ijkplayer=IJKFFMoviePlayerController.init(contentURL: videoURL, with: IJKFFOptions.byDefault())
//        playerView=ijkplayer?.view
//        playerView?.frame=CGRect.init(x: 0, y: 14, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*9/16);
//        self.view.addSubview(playerView!);
//
//        ijkplayer?.prepareToPlay()
//        ijkplayer?.play()
//       Alamofire.request("http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=11-4068648-1-0&r=456", method:.get).responseData
//        { [weak self] response in
//            self?.parser=XMLParser.init(data:response.result.value!)
//            //解析字符串格式的XML数据
//            //委托
//            self?.parser?.delegate = self
//            //开始解析
//            self?.parser?.parse()
//        }
        parser=XMLParser.init(contentsOf: URL.init(string: "http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=11-4068648-1-0&r=456")!)
        //解析字符串格式的XML数据
        //委托
        parser?.delegate = self
        //开始解析
        parser?.parse()
    }
    

    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        print(attributeDict)
    }

     func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        let str:String! = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if str != ""{
            print(str)
        }
    }

    @IBAction func full(_ sender: Any)
    {
        let fv = fullViewController()
        playerView?.frame = CGRect.init(x: 0, y: 0, width:UIScreen.main.bounds.size.height , height: UIScreen.main.bounds.size.width)
        fv.playerView=self.playerView
        self.present(fv, animated: false, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

