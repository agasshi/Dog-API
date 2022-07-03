//
//  ImageViewController.swift
//  Breed
//
//  Created by Stéphanie Sabine on 01/07/2022.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var url: String? = nil
    
    // MARK: Life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: UIBarButtonItem.Style.done, target: self, action: #selector(onClickDownload))
        
        self.view.backgroundColor = .systemGroupedBackground
        
        if let url = url {
            self.imageView.sd_setImage(with: URL(string: url))
        }
    }
    
    // MARK - Action
    @objc func onClickDownload()
    {
       
    }
}

