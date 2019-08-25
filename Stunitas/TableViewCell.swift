//
//  TableViewCell.swift
//  Stunitas
//
//  Created by 이관렬 on 25/08/2019.
//  Copyright © 2019 이관렬. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func refreshCell(handler:(() -> Void)){
        handler()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
