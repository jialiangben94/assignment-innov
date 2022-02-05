//
//  CommentViewController.swift
//  assignment-innov
//
//  Created by Benjamin on 04/02/2022.
//

import Foundation
import UIKit
import Alamofire

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var post: Post?
    var commentList: [Comment] = []
    var filteredList: [Comment] = []
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comment"
        viewModel = HomeViewModel(present: self)
        setupActivity()
        setupTableView()
        searchBar.delegate = self
        searchBar.isUserInteractionEnabled = false
        if let id = post?.id {
            viewModel?.getCommentList(id: id, completion: { [weak self] (response) in
                guard let sself = self else {return}
                sself.searchBar.isUserInteractionEnabled = true
                sself.commentList = response
                sself.filteredList = response
                sself.tableView.reloadData()
                sself.stopActivity()
            })
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        viewModel = nil
        super.dismiss(animated: flag, completion: completion)
    }
    
    func setupActivity() {
        activityIndicator.style = .large
        tableView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tablecell")
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = filteredList[indexPath.row].name
        content.secondaryText = filteredList[indexPath.row].body
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
    
}

extension CommentViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredList = searchText.isEmpty ? commentList : commentList.filter {(item: Comment) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive) != nil
        }
        
        tableView.reloadData()
    }
}
