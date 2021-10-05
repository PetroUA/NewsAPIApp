//
//  FavoritesViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 03.10.2021.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    let favoriteNewsData = FavoriteNewsData()
    var cellData: [FavoriteNews]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellData = favoriteNewsData.readFavoriteNews()
        tableView.reloadData()
    }
    
    func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        cellData = favoriteNewsData.readFavoriteNews()
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") as! NewsTableViewCell
        let imageUrl = URL(string: cellData?[indexPath.row].urlToImage ?? "")
        
        
        cell.newsItemIndex = indexPath.row
        cell.newsImage.image = nil
        cell.imageLoadingActivityIndicator.isHidden = false
        cell.imageLoadingActivityIndicator.startAnimating()
        cell.favoriteNewsButton.isHidden = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageUrl = imageUrl,
               let data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    guard cell.newsItemIndex == indexPath.row else {
                        return
                    }
                    cell.imageLoadingActivityIndicator.stopAnimating()
                    cell.imageLoadingActivityIndicator.isHidden = true
                    cell.newsImage.image = image
                }
            } else {
                DispatchQueue.main.async {
                    guard cell.newsItemIndex == indexPath.row else {
                        return
                    }
                    cell.imageLoadingActivityIndicator.stopAnimating()
                    cell.imageLoadingActivityIndicator.isHidden = true
                    cell.newsImage.image = UIImage(named: "newsIcon")
                }
            }
        }
        
        cell.titelLabel.text = cellData?[indexPath.row].title ?? ""
        cell.detailsLabel.text = cellData?[indexPath.row].newsDescription ?? ""
        cell.sourceLabel.text = cellData?[indexPath.row].sourceName ?? ""
        cell.authorLabel.text = cellData?[indexPath.row].author ?? ""
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url: URL = URL(string: (cellData?[indexPath.row].url)!) {
            let customViewController = CustomViewController.init()
            customViewController.cellURL = url
            self.navigationController?.pushViewController(customViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "News has not URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cellData?.remove(at: indexPath.row)
            favoriteNewsData.deleteFavoriteNews(id: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
}
