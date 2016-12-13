//
//  HJMainPageShowVideoTableViewCell.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/8.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJMainPageShowVideoTableViewCell: UITableViewCell {

    public var isreload:Bool?
    public var row:Int = 0
    @IBOutlet weak var scrollView: UICollectionView!
    
    @IBOutlet weak var titlelable: UILabel!
   
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        scrollView.register(UINib.init(nibName: "HJMainPageShowVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HJMainPageShowVideoCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize=CGSize.init(width: UIScreen.main.bounds.width/2-10, height: UIScreen.main.bounds.width/2+20)
        layout.minimumLineSpacing=5
        layout.minimumInteritemSpacing=0
        scrollView.collectionViewLayout=layout
    }

    public func reload()
    {
        if isreload == nil
        {
            scrollView.reloadData()
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
