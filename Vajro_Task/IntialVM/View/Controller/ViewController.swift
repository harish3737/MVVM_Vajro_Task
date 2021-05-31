//
//  ViewController.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var articlesTableView: UITableView!
    
    var intialVM : IntialVM?
    var intialModel : Model?
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialLoads()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
}

// #MARK:- Intiating Basic Functionality for View Controller
extension ViewController {
    private func intialLoads(){
        self.intialVM = IntialVM(vc: self)
        self.setTableFunctionalities()
        self.intialVM?.getModelResponse()
        self.intialVM?.onGetArticleData = { response in
            self.intialModel = response
            self.articlesTableView.reloadData()
        }
    }
// #MARK:- Intiating NavigationBar for View Controller
    private func setNavigationBar(){
        self.title = "Articles"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .red
    }
// #MARK:- Intiating TableView Functionalities
    private func setTableFunctionalities(){
        self.articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        self.articlesTableView.separatorStyle = .none
        self.articlesTableView.delegate = self
        self.articlesTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        self.articlesTableView.refreshControl = refreshControl
    }
// #MARK:- Refresh Action
    @objc func refreshAction(){
        self.intialVM?.getModelResponse()
        self.intialVM?.onGetArticleData = { response in
            self.intialModel = response
            DispatchQueue.main.async {
                self.articlesTableView.reloadData()
            }
           
        }
        self.refreshControl.endRefreshing()
    }
    
}
// #MARK:- Table View Delegate and Data Source
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intialModel?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        cell.selectionStyle = .none
        cell.articleImage.loadImageWithUrl(URL(string: intialModel?.articles?[indexPath.row].image?.src ?? "")!)
        cell.descriptionTextLabel.attributedText = intialVM?.getAttributedText(model: intialModel, index: indexPath.row)
        cell.imageVerticalHeight.constant = intialVM?.setHeightConstraints(contentHeight: cell.backgroundContentView.frame.width, width: intialModel?.articles?[indexPath.row].image?.width ?? 10, height: intialModel?.articles?[indexPath.row].image?.height ?? 10) ?? CGFloat(20)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        intialVM?.pushToNewViewController(htmlString: intialModel?.articles?[indexPath.row].body_html ?? "")
    }
    
}
