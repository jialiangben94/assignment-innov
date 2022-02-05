//
//  ViewController.swift
//  assignment-innov
//
//  Created by Benjamin on 04/02/2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModel?
    var postList: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Post"
        viewModel = HomeViewModel(present: self)
        self.tableView.isHidden = true
        setupActivity()
        setupTableView()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupActivity() {
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
    }
    
    func setupTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tablecell")
    }
    
    @objc func loadData() {
        viewModel?.getPostList(completion: { [weak self] (reponse) in
            guard let sself = self else {return}
            sself.postList = reponse
            sself.tableView.reloadData()
            sself.stopActivity()
            sself.tableView.refreshControl?.endRefreshing()
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = postList[indexPath.row].title
        content.secondaryText = postList[indexPath.row].body
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "CommentViewController") as! CommentViewController
        vc.post = postList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
