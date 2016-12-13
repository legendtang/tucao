//
//  HJVideoListTableViewCell.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/6.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJVideoListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var playBottom: NSLayoutConstraint!
    @IBOutlet weak var mukioLeft: NSLayoutConstraint!
    @IBOutlet weak var playlablebottom: NSLayoutConstraint!
    @IBOutlet weak var aImage: UIImageView!
    @IBOutlet weak var mukio: UILabel!
    @IBOutlet weak var play: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var titlelable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
