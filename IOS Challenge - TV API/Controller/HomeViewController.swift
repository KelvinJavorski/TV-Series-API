//
//  HomeViewController.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 01/02/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var pageRangeLabel: UILabel!
    @IBOutlet weak var showTableView: UITableView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentPage = 1
    
    var shows = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTableView.delegate = self
        showTableView.dataSource = self
        searchBar.delegate = self
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 15
        searchShows(currentPage)
    }
    
    func searchShows(_ page: Int){
        let fullURL = "\(ENDPOINT)shows?page=\(page)"
        
        DispatchQueue.main.async {
            guard let url = URL(string: fullURL),
            let data = try? Data(contentsOf: url) else { return }

            if let shows = try? JSONDecoder().decode([Show].self, from: data) {
                self.shows.removeAll()
                self.shows = shows
            } else {
                print("Decode error")
            }
            self.showTableView.reloadData()
        }
    }
    
    @IBAction func stepperCount(_ sender: UIStepper) {
        if sender.value > stepper.value {
            stepper.value += 1
        }else if sender.value < stepper.value {
            stepper.value -= 1
        }
        currentPage = Int(stepper.value)
        pageRangeLabel.text = "Page: \(currentPage)"
        searchShows(currentPage)
        showTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell
        let currentShow = shows[indexPath.row]
        
        if let image = currentShow.image {
            cell.showImage.load(url: image.original)
        }
        cell.showName.text = currentShow.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "homeToShowSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? SearchViewController {
            target.searchWord = searchBar.text
        }
        guard let selectedPath = showTableView.indexPathForSelectedRow else { return }
        if let target = segue.destination as? ShowViewController {
            target.selectedShow = shows[selectedPath.row]
        }
    }
}

extension HomeViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "homeToSearchSegue", sender: nil)
    }
}
