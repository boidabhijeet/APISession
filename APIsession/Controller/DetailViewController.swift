//
//  DetailViewController.swift
//  APIsession
//
//  Created by apple on 08/08/21.
//

import UIKit
import SDWebImage


class DetailViewController: UIViewController {

    var summary : String?
    var image : String?
    var name : String?
    var price : String?
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryLabel.text = "Summary"
        self.title = name
        priceLabel.text = price
        descText.text = summary
        imageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: ""))
    }
}
