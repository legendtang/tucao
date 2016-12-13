//
//  HJCommentTableViewCell.swift
//  tucao
//
//  Created by 辉仔 on 2016/11/16.
//  Copyright © 2016年 辉仔. All rights reserved.
//

import UIKit

class HJCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
