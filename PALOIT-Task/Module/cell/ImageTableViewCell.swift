//
//  ImageTableViewCell.swift
//  PALOIT-Task
//
//  Created by Bhagyashree Khatri on 20/07/24.
//

import UIKit
import SDWebImage

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImageView.sd_imageTransition = .fade // Optional: Add a fade transition for image loading
    }
    
    func configure(with image: ImageModel) {
        let placeholderImage = UIImage(named: "placeholder")
        authorLabel.text = "By: \(image.author)"
        self.contentView.alpha = 0.3
        photoImageView.accessibilityIdentifier = "PhotoImageView" // Add identifier here
        authorLabel.accessibilityIdentifier = "AuthorLabel" // Add identifier here
        guard let imageURL = URL(string: image.download_url) else {
            photoImageView.image = UIImage(named: "placeholder") // Placeholder image if URL is invalid
            return
        }
        
        // Use SDWebImage for asynchronous image loading and caching
        photoImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: [], completed: { (image, error, cacheType, imageURL) in
            if let error = error {
                // Handle SDWebImage errors
                print("Error loading image: \(error.localizedDescription)")
                self.photoImageView.image = placeholderImage
            }
            // Optionally resize the image if needed
            // Example: Resize image to fit imageView bounds
            if let resizedImage = image?.sd_resizedImage(with: self.photoImageView.bounds.size, scaleMode: .aspectFill) {
                DispatchQueue.main.async {
                    self.photoImageView.image = resizedImage
                }
                self.contentView.alpha = 1
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.sd_cancelCurrentImageLoad() // Cancel ongoing image loading when cell is reused
        photoImageView.image = nil // Clear the image to ensure correct reuse behavior
    }
}

