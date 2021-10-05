//
//  NewsTableViewCell.swift
//  TestTaskPecode
//
//  Created by Petro on 30.09.2021.
//

import UIKit
protocol NewsTableViewCellDelegate: AnyObject {
  func newsTableViewCell(_ newsTableViewCell: NewsTableViewCell, ButtonTappedFor youtuber: Int)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteNewsButton: UIButton!
    
    let favoriteNewsData = FavoriteNewsData()
    
    weak var delegate : NewsTableViewCellDelegate?
    
    var newsItemIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.favoriteNewsButton.addTarget(self, action: #selector(ButtonTapped(_:)), for: .touchUpInside)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func ButtonTapped(_ sender: UIButton){
        self.delegate?.newsTableViewCell(self, ButtonTappedFor: newsItemIndex!)
    }
}
