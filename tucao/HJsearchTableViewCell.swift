//
//  HJsearchTableViewCell.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/22.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJsearchTableViewCell: UITableViewCell {

    @IBOutlet weak var aimage: UIImageView!
    @IBOutlet weak var videotitle: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var paly: UILabel!
    @IBOutlet weak var danmakulable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
