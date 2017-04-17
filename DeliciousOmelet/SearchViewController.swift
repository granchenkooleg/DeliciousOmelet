//
//  SearchViewController.swift
//  DeliciousOmelet
//
//  Created by Oleg on 3/26/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit
import SDWebImage


class SearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchTextField: TextField?
    
    //var food = [Result]()
    var foodContainer = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call path RealmDB
        Foods.setConfig()
        
        // Resize dynamic cell
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        spiner.hidesWhenStopped = true
        spiner.activityIndicatorViewStyle = .gray
        view.addSubview(spiner)
        spiner.center.x = view.center.x
        spiner.center.y = view.center.y
        spiner.startAnimating()
        
        
        // Check Internet connection
        guard isNetworkReachable() == true  else {
            // Data from DB
            foodContainer = Foods().allFood()
            return
        }
        
        // Call API method
        let param : Dictionary = [
            "i" : "onions",
            "q" : "omelet",
            "p" : "3"]
        UserRequest.recipePuppy (param as [String : AnyObject], completion: { [weak self]  json in
            Foods.delAllFoods()
            Foods.setupFood(json: json)
            self?.foodContainer = Foods().allFood()
            self?.spiner.stopAnimating()
            self?.tableView?.reloadData()
        })
        
        tableView?.separatorStyle = .none
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if text.isEmpty {
                foodContainer = Foods().allFood()
            } else {
                // Check Internet connection
                if isNetworkReachable() == true {
                    let text = text.removingPercentEncoding
                    let param: Dictionary = ["q" : text]
                    UserRequest.searchURL(param as [String : AnyObject], completion: {  [ weak self] json in
                        guard json["results"].arrayValue.count > 0 else {return}
                        Foods.delAllFoods()
                        self?.foodContainer = []
                        Foods.setupFood(json: json)
                        self?.foodContainer = Foods().allFood()
                        self?.tableView.reloadData()
                    })
                } else {
                    // Data from DB
                    foodContainer = Foods().allFood().filter { $0.title.lowercased().range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil }
                }
            }
        }
        tableView.reloadData()
     
        return true
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodContainer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchTableViewCell
        
        let foodDetails = foodContainer[indexPath.row]
        
        DispatchQueue.main.async { _ in
            cell.thubnailImageView?.sd_setImage(with: URL(string: (foodDetails.thumbnail)))
        }
        cell.titleLabel?.text = foodDetails.title
        cell.ingredientsLabel?.text = foodDetails.ingredients
        
        return cell
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = foodContainer[indexPath.row]
        guard let url = URL(string: result.href) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thubnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thubnailImageView?.layer.cornerRadius = 30
        thubnailImageView?.layer.masksToBounds = true
    }
}
