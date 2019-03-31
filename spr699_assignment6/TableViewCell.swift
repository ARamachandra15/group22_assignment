//
//  TableViewCell.swift
//  spr699_assignment6
//
//  Created by Slijepcevic, Milica on 3/26/19.
//  Copyright © 2019 Samuel Randall. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"

    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var HPLabel: UILabel!
    @IBOutlet weak var advImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
