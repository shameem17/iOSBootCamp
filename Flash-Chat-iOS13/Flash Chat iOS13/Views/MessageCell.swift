//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Shameem on 14/10/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rightAvatar: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bubbleView.layer.cornerRadius = self.bubbleView.frame.height/4
    }

    
}
