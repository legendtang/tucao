//
//  MainPageViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/4.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit
import  Alamofire
import KYDrawerController


class MainPageViewController: UIViewController,UIScrollViewDelegate
{
    @IBOutlet weak var openDrawButton: UIButton!
    @IBOutlet weak var titleScrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    var vc:KYDrawerController?
    var beSelectedButton:UIButton?
    let titleButtonWidth:CGFloat = 70.0
    var titleSelectView:UIView?
    var titleButtonArray:[UIButton]?=[]
    var VCArray:[HJClassifyTableViewController]?
    var nowpage:Int?=0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        vc?.screenEdgePanGestureEnabled=true;
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        vc?.screenEdgePanGestureEnabled=false;
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUp()
    }

    func setUp()
    {
        vc=self.navigationController?.parent as? KYDrawerController
//        self.navigationController?.navigationBar.backgroundColor=UIColor.blue
        self.navigationController?.navigationBar.isTranslucent=false
        self.navigationController?.navigationBar.backgroundColor=UIColor.blue
        self.navigationController?.navigationBar.barStyle=UIBarStyle.black
//        let ii:UIImage=UIImage.init()
        let negativeSpacer:UIBarButtonItem=UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -9
        self.navigationItem.leftBarButtonItems?.insert(negativeSpacer, at: 0)
        openDrawButton.layer.cornerRadius=openDrawButton.frame.width/2
        openDrawButton.layer.borderWidth=1
        openDrawButton.layer.borderColor=UIColor.white.cgColor
        openDrawButton.layer.masksToBounds=true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "bule2"), for: UIBarMetrics.default)
        mainScrollView.delegate=self
        titleSelectView=UIView.init()
        titleSelectView?.backgroundColor=UIColor.blue
        titleSelectView?.frame=CGRect.init(x: 0, y: Int(titleScrollView.frame.size.height)-3, width: Int(titleButtonWidth), height: 3)
        titleScrollView.addSubview(titleSelectView!)
        self.mainScrollView.isPagingEnabled=true;
        self.automaticallyAdjustsScrollViewInsets = false;
        self.titleScrollView.contentSize = CGSize.init(width:Int (titleButtonWidth*7), height: Int(titleScrollView.frame.size.height))
        let  titleArray = ["全部","动画","新番","游戏","音乐","影视","其他"]
        for i in 0...6
        {
            let button =  UIButton.init(frame: CGRect.init(x: i*Int(titleButtonWidth), y: 0, width: Int(titleButtonWidth), height: Int(titleScrollView.frame.size.height)))
            button.tag=i
            button.setTitle(titleArray[i], for: UIControl.State.normal)
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.addTarget(self, action: #selector(self.touchTitleButtonAction(sender:)), for: UIControl.Event.touchUpInside)
            titleButtonArray?.append(button)
            titleScrollView.addSubview(button)
        }
        beSelectedButton=titleButtonArray?[0]
        beSelectedButton?.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        mainScrollView.contentSize=CGSize.init(width: UIScreen.main.bounds.size.width*7, height:0)
        
        let mainsb=UIStoryboard.init(name: "Main", bundle: nil)
        
        let newAnimeVC:HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        newAnimeVC.classify=ViewControllerClassify.newAnime
        newAnimeVC.title="新番"

        let filmVC :HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        filmVC.classify=ViewControllerClassify.film
        filmVC.title="影视"

        let gameVC:HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        gameVC.classify=ViewControllerClassify.game
        gameVC.title="游戏"
        
        let MusicVC :HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        MusicVC.classify=ViewControllerClassify.Music
        MusicVC.title="音乐"
        
        let animationVC:HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        animationVC.classify=ViewControllerClassify.animation
        animationVC.title="动画"

        let otherVC :HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        otherVC.classify=ViewControllerClassify.other
        otherVC.title="其他"

        let allVC:HJClassifyTableViewController = mainsb.instantiateViewController(withIdentifier: "HJClassifyTableViewController") as! HJClassifyTableViewController
        allVC.classify=ViewControllerClassify.all
        
        VCArray = [allVC,animationVC,newAnimeVC,gameVC,MusicVC,filmVC,otherVC]
    
        for i in 0...6
        {
            let VC:HJClassifyTableViewController = VCArray![i]
            VC.view.frame=CGRect.init(x: Int(UIScreen.main.bounds.size.width)*i, y: 0, width: Int(self.mainScrollView.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
            self.addChild(VC)
            mainScrollView.addSubview(VC.view)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {

        let x=mainScrollView.contentOffset.x/mainScrollView.contentSize.width*titleButtonWidth*7.0
        titleSelectView?.frame=CGRect.init(x: CGFloat(x), y: (titleSelectView?.frame.origin.y)!, width: (titleSelectView?.frame.size.width)!, height: (titleSelectView?.frame.size.height)!)
        let page:Int=Int(mainScrollView.contentOffset.x/mainScrollView.contentSize.width*7.0+0.5)
        nowpage=page
        switch page
    {
        case 0:
            self.changeBeSelectedButton(page: page)
            break;
        case 1:
            self.changeBeSelectedButton(page: page)
            break;
        case 2:
            self.changeBeSelectedButton(page: page)
            break;
        case 3:
            self.changeBeSelectedButton(page: page)
            break;
        case 4:
            self.changeBeSelectedButton(page: page)
            break;
        case 5:
            self.changeBeSelectedButton(page: page)
            break;
        case 6:
            self.changeBeSelectedButton(page: page)
            break;
        default:
            break;
        }
    }
    
    @objc func touchTitleButtonAction(sender:UIButton)
    {
        let tag=CGFloat(sender.tag)
        mainScrollView.setContentOffset(CGPoint.init(x: mainScrollView.frame.size.width*tag, y: 0), animated: true)
    }
    
    
    func changeBeSelectedButton(page:Int)
    {
        beSelectedButton?.setTitleColor(UIColor.black, for: UIControl.State.normal)
        beSelectedButton = titleButtonArray?[page]
        beSelectedButton?.setTitleColor(UIColor.blue, for: UIControl.State.normal)
    }
    
    
    //MARK:-ScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let childViewController:HJClassifyTableViewController=VCArray![nowpage!]
        if childViewController.isreload != true
        {
            childViewController.tableView.reloadData()
            childViewController.isreload=true
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        let childViewController:HJClassifyTableViewController=VCArray![nowpage!]
        if childViewController.isreload != true
        {
            childViewController.tableView.reloadData()
            childViewController.isreload=true
        }
    }



    @IBAction func opendrawview(_ sender: Any)
    {
        vc?.setDrawerState(KYDrawerController.DrawerState.opened, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
