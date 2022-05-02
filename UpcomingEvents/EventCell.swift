//
//  EventCell.swift
//  UpcomingEvents
//
//  Created by Venkata Sudheer Muthineni on 5/1/22.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        imageview.image = nil
    }
}
