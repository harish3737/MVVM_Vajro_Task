//
//  ArticleTableViewCell.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var articleImage: ImageLoader!
    
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var imageVerticalHeight: NSLayoutConstraint!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   
    }
    
}
