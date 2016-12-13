//
//  HJAdvertisementViewController.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/17.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJAdvertisementViewController: UIViewController,UIScrollViewDelegate
{
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLable: UILabel!
    public var modellist:[HJVedioMessageModle]?
    public var imagearray:[UIImageView]?
    public var titlearray:[String]?
    var timer:Timer?

    override func viewWillAppear(_ animated: Bool)
    {
        timer=Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(self.cutPage), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        timer?.invalidate()
        timer=nil
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleLable.font=UIFont.systemFont(ofSize: 12)
        imagearray=[]
        titlearray=[]
        modellist=[]
        scrollView.delegate=self
        scrollView.contentSize=CGSize.init(width: UIScreen.main.bounds.width*4, height: 0)
        scrollView.isPagingEnabled=true
        self.view.layoutIfNeeded()
        for i in 0...3
        {
            let tapOne:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.touchImageAction(sender:)))
            tapOne.numberOfTapsRequired = 1
            tapOne.numberOfTouchesRequired = 1
            let title:String="???"
            titlearray?.append(title)
            let imageView:UIImageView=UIImageView.init(frame: CGRect.init(x: UIScreen.main.bounds.width*CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height:  scrollView.frame.height))
            imageView.tag=i
            imageView.addGestureRecognizer(tapOne)
            imagearray?.append(imageView)
            scrollView.addSubview(imageView)
        }
        // Do any additional setup after loading the view.
    }
    
    func cutPage()
    {
        if scrollView.contentOffset.x != scrollView.frame.width*3
        {
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentOffset.x + UIScreen.main.bounds.width, y: 0), animated: true)
        }
        else
        {
           scrollView.setContentOffset(CGPoint.init(x:0, y: 0), animated: true)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let index:Int=Int(scrollView.contentOffset.x/scrollView.frame.width+0.5)
        pageControl.currentPage=index
        if index <= (titlearray?.count)!-1
        {
            self.titleLable.text=titlearray?[index]
        }
    }
    
    func touchImageAction(sender:Any)
    {
        let s:UITapGestureRecognizer=sender as! UITapGestureRecognizer
        if  s.view!.tag < modellist!.count
        {
            let sm:UIStoryboard=UIStoryboard.init(name: "Main", bundle: nil)
            let vc:HJPlayViewController = sm.instantiateViewController(withIdentifier: "HJPlayViewController") as! HJPlayViewController
            let modle:HJVedioMessageModle=self.modellist![(s.view?.tag)!]
            vc.videolist=modle.video
            vc.playTitle=modle.title as String?
            vc.thumb=modle.thumb as String?
            vc.descriptions=modle.descriptions as String?
            vc.mukio = modle.mukio  as String?
            vc.user=modle.user as String?
            vc.play=modle.play as String?
            vc.hid=modle.hid as String?
            vc.tid=modle.tid as String?
            self.parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        timer?.invalidate()
        timer=nil
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        timer=Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(self.cutPage), userInfo: nil, repeats: true)
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
