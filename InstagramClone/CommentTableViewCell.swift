//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by Jibril Mohamed on 4/1/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentedUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
