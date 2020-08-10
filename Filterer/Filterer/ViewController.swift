//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

enum FilterButtonTag: Int {
    case filter1 = 1
    case filter2 = 2
    case filter3 = 3
    case filter4 = 4
    case filter5 = 5
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var filteredImage: UIImage?
    var originalImage: UIImage?
    var showOriginalImage: Bool = false

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var originalImageLabel: UIView!

    @IBOutlet weak var filterMenuView: UIStackView!
    @IBOutlet weak var filterButton1: UIButton!
    @IBOutlet weak var filterButton2: UIButton!
    @IBOutlet weak var filterButton3: UIButton!
    @IBOutlet weak var filterButton4: UIButton!
    @IBOutlet weak var filterButton5: UIButton!

    @IBOutlet var editMenuView: UIView!
    @IBOutlet weak var sliderView: UISlider!

    var selectedFilterOption: FilterButtonTag?

    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        self.getOriginalImage()
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera

            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func showAlbum() {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Alright", style: .default, handler: { (alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {

            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .photoLibrary

            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
            self.getOriginalImage()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu(editMenuVisible: false)
            sender.isSelected = true
        }
    }
    
    func showSecondaryMenu(editMenuVisible: Bool) {
        self.editMenuView.isHidden = !editMenuVisible
        self.filterMenuView.isHidden = editMenuVisible

        if self.filterButton.isSelected && editMenuVisible {
            self.filterButton.isSelected = false
        } else if self.editButton.isSelected {
            self.editButton.isSelected = false
        }

        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 75)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])

        self.setSecondaryViewButtonProperties()
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

    //MARK: Compare Menu
    @IBAction func onCompareWithSender(_ sender: Any) {
        self.showOriginalImage = !self.showOriginalImage
        self.showImage(original: self.showOriginalImage)
    }

    @IBAction func onImageTouchEvent(_ sender: UILongPressGestureRecognizer) {
        if(self.filteredImage != nil) {
            if(sender.state == UIGestureRecognizer.State.began) {
                self.showImage(original: true)
            } else if(sender.state == UIGestureRecognizer.State.ended) {
                self.showImage(original: false)
            }
        }
    }

    func showImage(original: Bool) {
        self.imageView.alpha = 0
        UIView.transition(with: imageView, duration: 0.33, options: .transitionCrossDissolve, animations: {
              if(original) {
                  self.originalImageLabel.isHidden = false
                  self.imageView.image = self.originalImage
              } else {
                  self.originalImageLabel.isHidden = true
                  self.imageView.image = self.filteredImage
              }
              self.imageView.alpha = 1
        }, completion: nil)
//        UIView.animate(withDuration: 0.5) {
//        }

    }

    //MARK: Filter Menu
    func getOriginalImage() {
        self.compareButton.isEnabled = false
        self.editButton.isEnabled = false
        self.originalImageLabel.isHidden = true
        self.originalImage = self.imageView.image
    }

    func setSecondaryViewButtonProperties() {
        if let image = self.filterButton1.currentImage {
            self.filterButton1.tag = FilterButtonTag.filter1.rawValue
            let filter = self.getSelectedFilter(filterTag: FilterButtonTag.filter1)
            let filterButtonImage = filter.imageProcessor.processImage(image: image)
            self.filterButton1.setImage(filterButtonImage , for: .normal)
        }

        if let image = self.filterButton2.currentImage {
            self.filterButton2.tag = FilterButtonTag.filter2.rawValue
            let filter = self.getSelectedFilter(filterTag: FilterButtonTag.filter2)
            let filterButtonImage = filter.imageProcessor.processImage(image: image)
            self.filterButton2.setImage(filterButtonImage , for: .normal)
        }

        if let image = self.filterButton3.currentImage {
            self.filterButton3.tag = FilterButtonTag.filter3.rawValue
            let filter = self.getSelectedFilter(filterTag: FilterButtonTag.filter3)
            let filterButtonImage = filter.imageProcessor.processImage(image: image)
            self.filterButton3.setImage(filterButtonImage , for: .normal)
        }

        if let image = self.filterButton4.currentImage {
            self.filterButton4.tag = FilterButtonTag.filter4.rawValue
            let filter = self.getSelectedFilter(filterTag: FilterButtonTag.filter4)
            let filterButtonImage = filter.imageProcessor.processImage(image: image)
            self.filterButton4.setImage(filterButtonImage , for: .normal)
        }

        if let image = self.filterButton5.currentImage {
            self.filterButton5.tag = FilterButtonTag.filter5.rawValue
            let filter = self.getSelectedFilter(filterTag: FilterButtonTag.filter5)
            let filterButtonImage = filter.imageProcessor.processImage(image: image)
            self.filterButton5.setImage(filterButtonImage , for: .normal)
        }

    }

    @IBAction func onFilterOptionWithSender(_ sender: Any) {
        self.imageView.image = self.originalImage
        let filterTag = FilterButtonTag(rawValue: (sender as! UIButton).tag)
        print("filterTag ==== \(String(describing: filterTag))")

        if let image = self.originalImage, let tag = filterTag {
            let filter = self.getSelectedFilter(filterTag: tag)
            let filterImage = filter.imageProcessor.processImage(image: image)
            self.filteredImage = filterImage
            self.sliderView.value = Float(filter.intensity)
            self.selectedFilterOption = tag
        }
        self.imageView.image = self.filteredImage
        self.compareButton.isEnabled = true
        self.editButton.isEnabled = true
    }

    func getSelectedFilter(filterTag: FilterButtonTag, intensity: Double = FilterIntensity.defaultIntensity.rawValue) -> (imageProcessor: ImageProcessor, intensity: Double) {
        let imageProcessor: ImageProcessor = ImageProcessor()
        switch filterTag {
        case .filter1:
            imageProcessor.addFilter(filter: FilterType.transperency, filterIntensity: intensity)

        case .filter2:
            imageProcessor.addFilter(filter: FilterType.intensifyColor, filterOption: FilterOption.colorRed, filterIntensity: intensity)

        case .filter3:
            imageProcessor.addFilter(filter: FilterType.invertColor, filterIntensity: intensity)

        case .filter4:
            imageProcessor.addFilter(filter: FilterType.removeColor, filterOption: FilterOption.colorBlue, filterIntensity: intensity)

        case .filter5:
            imageProcessor.addFilter(filter: FilterType.monochromeColor, filterIntensity: intensity)
        }
        return (imageProcessor, intensity)
    }

    //MARK: Edit Menu

    @IBAction func onEditWithSender(_ sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu(editMenuVisible: true)
            sender.isSelected = true
        }
    }

    @IBAction func onSliderValueChangeWithSender(_ sender: UISlider) {
        print(sender.value)

        if let image = self.originalImage, let tag = self.selectedFilterOption {
            let filter = self.getSelectedFilter(filterTag: tag, intensity: Double(sender.value))
            let filterImage = filter.imageProcessor.processImage(image: image)
            self.filteredImage = filterImage
            self.sliderView.value = Float(filter.intensity)
        }
        self.imageView.image = self.filteredImage
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
