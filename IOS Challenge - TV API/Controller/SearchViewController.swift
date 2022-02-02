//
//  ViewController.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 30/01/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var searchWord : String?
    var shows = [Show]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        if let searchWord = searchWord {
            searchShows(named: searchWord)
        }
    }
    
    func searchShows(named name: String){
        let queryStr = formatToQueryString(name)
        let fullURL = "\(ENDPOINT)search/shows?q=\(queryStr)"
        
        DispatchQueue.main.async {
            guard let url = URL(string: fullURL),
            let data = try? Data(contentsOf: url) else { return }

            if let search = try? JSONDecoder().decode([Search].self, from: data) {
                self.shows.removeAll()
                for found in search {
                    self.shows.append(found.show)
                }
            } else {
                print("Decode error")
            }
            self.searchTableView.reloadData()
        }
    }
    
    func formatToQueryString(_ string: String) -> String {
        return string.components(separatedBy: " ").joined(separator: "%20")
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
        let currentShow = shows[indexPath.row]
        
        cell.showTitle.text = currentShow.name
        
        if let image = currentShow.image {
            cell.showImage.load(url: image.medium)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = searchTableView.indexPathForSelectedRow else { return }
        if let target = segue.destination as? ShowViewController {
            target.selectedShow = shows[selectedPath.row]
        }
        
    }
}

