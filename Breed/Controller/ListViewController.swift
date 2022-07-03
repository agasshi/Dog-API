//
//  ViewController.swift
//  Breed
//
//  Created by Stéphanie Sabine on 01/07/2022.
//

import UIKit
import Alamofire

class ListViewController: UITableViewController
{
    private let allUrl = "https://dog.ceo/api/breeds/list/all"
    private let breedUrl = "https://dog.ceo/api/breed/%@/list"
    
    private var emptyLabel: UILabel? = nil
    
    var breed: String? = nil
    var items: [Breed] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = breed?.capitalized ?? "Dog API"
        self.navigationItem.largeTitleDisplayMode = self.items.count > 0 ? .never : .always
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BreedCell")
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGroupedBackground
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight]
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        self.tableView.backgroundView = backgroundView
        
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
        refreshControl.attributedTitle = NSAttributedString(string: "Pull-to-Refresh")
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(onLoadItems(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if items.count == 0 {
            self.tableView.refreshControl?.sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Request
    private func requestAllBreeds(_ sender: UIRefreshControl)
    {
        AF.request(allUrl).responseDecodable(of: ResponseObject.self) { body in
            sender.endRefreshing()
            guard let response = body.value else {
                self.reloadMessage(body.error)
                return
            }
            
            self.reloadData(response)
            self.reloadMessage(nil)
        }
    }
    
    private func requestAllSubBreeds(_ sender: UIRefreshControl)
    {
        AF.request(String(format: breedUrl, breed ?? "")).responseDecodable(of: ResponseArray.self) { body in
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
    private func reloadData(_ response: Any)
    {
        self.items.removeAll()
        
        if let value = response as? ResponseObject {
            for item in value.message
            {
                let breeds = item.value.map { Breed(name: $0, breeds: []) }
                self.items.append(Breed(name: item.key, breeds: breeds))
            }
        }
        else if let value = response as? ResponseArray {
            for item in value.message
            {
                self.items.append(Breed(name: item, breeds: []))
            }
        }
        
        self.items.sort { $0.name < $1.name }
        self.tableView.reloadData()
    }
    
    private func reloadMessage(_ response: AFError?)
    {
        // TODO: Optmized error and empty message according situation
        self.emptyLabel?.text = response?.errorDescription ?? "Empty"
        self.emptyLabel?.isHidden = self.items.count > 0
    }
    
    // MARK: - Action
    @objc func onLoadItems(_ sender: UIRefreshControl)
    {
        guard let _ = breed else {
            requestAllBreeds(sender)
            return
        }
        
        requestAllSubBreeds(sender)
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.font = .preferredFont(forTextStyle: .title2)
        cell.textLabel?.text = self.items[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = self.items[indexPath.row]
        if item.breeds.count == 0 {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Breed") as! BreedViewController
            viewController.root = breed
            viewController.breed = item.name
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "List") as! ListViewController
            viewController.breed = item.name
            //viewController.items = item.breeds
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

