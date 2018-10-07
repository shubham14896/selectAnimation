//
//  ViewController.swift
//  RateFood
//
//  Created by Shubham Gupta on 06/10/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 6
        
        let images = [UIImage(named: "received"), UIImage(named: "approved"), UIImage(named: "preparing"), UIImage(named: "packed"), UIImage(named: "outForDelivery"), UIImage(named: "rated")]
        
        let arrangedSubViews = images.enumerated().map({ (index, image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.distribution = .fillEqually

        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubViews.count)
        let width = numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        containerView.layer.shadowColor = UIColor.init(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        
        return containerView
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var currentImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
    }

    fileprivate func setupLongPressGesture(){
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: self.iconsContainerView.frame.height)
                self.iconsContainerView.alpha = 0
                
            }) { (_) in
                self.iconsContainerView.removeFromSuperview()
            }
            
            imageView.image = currentImage.image
            let currTag = currentImage.tag
            
            if(currTag == 0){
                statusLabel.text = "Received"
            } else if (currTag == 1){
                statusLabel.text = "Approved"
            } else if (currTag == 2){
                statusLabel.text = "Preparing"
            } else if (currTag == 3){
                statusLabel.text = "Packed"
            } else if (currTag == 4){
                statusLabel.text = "Out For Delivery"
            } else if (currTag == 5){
                statusLabel.text = "Delivered & Rated"
            }
            
            
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer){
        let gestureLocation = gesture.location(in: self.iconsContainerView)
        
        let fixedYLocation = CGPoint(x: gestureLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })

                if let imageView = hitTestView as? UIImageView{
                    self.currentImage = imageView
                }
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    
    }
    
    fileprivate
    func handleGestureBegan(gesture: UILongPressGestureRecognizer){
        
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0
        iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })
    }
    
    override var prefersStatusBarHidden: Bool {return true}

}

