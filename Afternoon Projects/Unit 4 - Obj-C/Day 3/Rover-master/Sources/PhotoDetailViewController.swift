//
//  PhotoDetailViewController.swift
//  Rover
//
//  Created by Andrew Madsen on 2/27/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateViews()
	}
	
	private func updateViews() {
		guard isViewLoaded else { return }
		guard let photo = photo else {
			imageView.image = #imageLiteral(resourceName: "MarsPlaceholder")
			cameraLabel.text = ""
			solLabel.text = ""
			dateLabel.text = ""
			return
		}
		
		cameraLabel.text = photo.cameraName
		solLabel.text = "\(photo.sol)"
		dateLabel.text = PhotoDetailViewController.dateFormatter.string(from: photo.earthDate)
		
		let cache = DMNPhotoCache.shared
		if let imageData = cache?.imageData(forIdentifier: photo.identifier),
			let image = UIImage(data: imageData) {
			imageView.image = image
		} else {
			client.fetchImageData(for: photo) { (data, error) in
				if error != nil || data == nil {
					NSLog("Error fetching photo for: \(String(describing: error))")
					return
				}
				
				if let image = UIImage(data: data!),
					self.photo == photo {
					DispatchQueue.main.async {
						self.imageView.image = image
					}
				}
			}
		}
		
	}
	
	var photo: DMNMarsPhoto? {
		didSet {
			updateViews()
		}
	}
	
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.timeStyle = .none
		formatter.dateStyle = .short
		formatter.doesRelativeDateFormatting = true
		return formatter
	}()
	
	private let client = DMNMarsRoverClient()

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var cameraLabel: UILabel!
	@IBOutlet var solLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
}
