//
//  PostTableViewCell.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 3/25/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var postImagView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
