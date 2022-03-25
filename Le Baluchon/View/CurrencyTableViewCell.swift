//
//  CurrencyTableViewCell.swift
//  Le Baluchon
//
//  Created by Yoan on 18/03/2022.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var countryReferenceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(key: String, countryReference: String?, value: Float?) {
        guard countryReference != nil else {
            return
        }
        guard let value = value else {
            return
        }
        keyLabel.text = key
        valueLabel.text = String(value)
        countryReferenceLabel.text = countryReference
    }
}
