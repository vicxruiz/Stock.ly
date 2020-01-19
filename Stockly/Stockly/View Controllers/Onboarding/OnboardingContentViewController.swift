//
//  OnboardingContentViewController.swift
//  Stockly
//
//  Created by Victor Ruiz on 1/18/20.
//  Copyright © 2020 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class OnboardingContentViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var headingLabel: UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var subheadingLabel: UILabel! {
        didSet {
            subheadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = heading
        subheadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }
}
