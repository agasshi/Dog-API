//
//  BreedViewController.swift
//  Breed
//
//  Created by Stéphanie Sabine on 01/07/2022.
//

import UIKit
import SDWebImage
import Alamofire

class BreedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    private let imagesUrl = "https://dog.ceo/api/breed/%@/images"
    private let minimumItemSpacing = 10.0
    private let numberOfColumns = 3
    
    private var emptyLabel: UILabel? = nil
    
    var root: String? = nil
    var breed: String? = nil
    var images: [String] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = breed?.capitalized
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.collectionView.backgroundColor = .systemGroupedBackground
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGroupedBackground
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight]
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        self.collectionView.backgroundView = backgroundView
        
        let emptyLabel = UILabel()
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.font = .preferredFont(forTextStyle: .caption2)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emptyLabel = emptyLabel
        backgroundView.addSubview(emptyLabel)
        
        let views = ["label": emptyLabel]
        backgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=20)-[label(>=0)]-(>=20)-|", metrics: nil, views: views))
        backgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=20)-[label(>=0)]-(>=20)-|", metrics: nil, views: views))
        backgroundView.addConstraint(emptyLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        backgroundView.addConstraint(emptyLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor))
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(onLoadImages(_:)), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if images.count == 0 {
            self.collectionView.refreshControl?.sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Request
    @objc func onLoadImages(_ sender: UIRefreshControl)
    {
        guard let breed = breed else {
            sender.endRefreshing()
            return
        }
        
        let path: String
        if let root = root {
            path = String(format: imagesUrl, "\(root)/\(breed)")
        }
        else {
            path = String(format: imagesUrl, breed)
        }

        AF.request(path).responseDecodable(of: ResponseArray.self) { body in
            sender.endRefreshing()
            guard let response = body.value else {
                self.reloadMessage(body.error)
                return
            }
            
            self.reloadData(response)
            self.reloadMessage(nil)
        }
    }
    
    // MARK: - Reload
    private func reloadData(_ response: ResponseArray)
    {
        self.images.removeAll()
        response.message.forEach { self.images.append($0) }
        self.collectionView.reloadData()
    }
    
    private func reloadMessage(_ response: AFError?)
    {
        // TODO: Optmized error and empty message according situation
        self.emptyLabel?.text = response?.errorDescription ?? "Empty"
        self.emptyLabel?.isHidden = self.images.count > 0
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return minimumItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return minimumItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let spacing = collectionView.safeAreaInsets.left + collectionView.contentInset.left + (minimumItemSpacing * CGFloat(numberOfColumns - 1)) + collectionView.contentInset.right + collectionView.safeAreaInsets.right
        let itemSize = ((collectionView.frame.size.width - spacing) / CGFloat(numberOfColumns)).rounded(.down)
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if cell.contentView.subviews.count == 0 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.sd_setImage(with: URL(string: images[indexPath.row]))
            cell.contentView.backgroundColor = .white
            cell.contentView.addSubview(imageView)
            
            let views = ["imageView": imageView]
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[imageView(>=0)]-|", metrics: nil, views: views))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[imageView(>=0)]-|", metrics: nil, views: views))
        } else if let imageView = cell.contentView.subviews[0] as? UIImageView {
            imageView.sd_setImage(with: URL(string: images[indexPath.row]))
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Image") as! ImageViewController
        viewController.title = self.title
        viewController.url = images[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
