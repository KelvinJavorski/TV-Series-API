//
//  ShowViewController.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 31/01/22.
//

import UIKit

class ShowViewController: UIViewController {
    
    var selectedShow : Show?
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timeAirLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var episodesCollection: UICollectionView!
    @IBOutlet weak var seasonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodesCollection.delegate = self
        episodesCollection.dataSource = self
        episodesCollection.decelerationRate = UIScrollView.DecelerationRate.normal
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setShowInformations()
        episodesCollection.reloadData()
    }
    
    func formatToQueryString(_ string: String) -> String {
        return string.components(separatedBy: " ").joined(separator: "%20")
    }

    func loadEpisodes(named name: String){
        let nameStr = formatToQueryString(name)
        let fullUrl = "\(ENDPOINT)singlesearch/shows?q=\(nameStr)&embed=episodes"
        
        DispatchQueue.main.async {
            guard let url = URL(string: fullUrl),
            let data = try? Data(contentsOf: url) else { return }
            
            if let show = try? JSONDecoder().decode(Show.self, from: data){
                self.selectedShow = show
            } else {
                print("Decode error")
            }
            self.episodesCollection.reloadData()
        }
    }
    
    func setShowInformations(){
        if let show = selectedShow{
            showLabel.text = show.name
            if let image = show.image {
                posterImageView.load(url: image.medium)
            }
            let concatenatedGenres = show.genres.joined(separator: ", ")
            genreLabel.text = "Genres: \(concatenatedGenres)"
            if let runtime = show.runtime{
                timeAirLabel.text = String(runtime)
            }
            
            let summary = show.summary.htmlToString
            summaryLabel.text = summary
            summaryLabel.numberOfLines = 4
            loadEpisodes(named: show.name)
        }
           
    }
}

extension ShowViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let episodes = selectedShow?._embedded?.episodes{
            return episodes.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = episodesCollection.dequeueReusableCell(withReuseIdentifier: "episodesCell", for: indexPath) as! EpisodeCollectionViewCell
        if let episode = selectedShow?._embedded?.episodes![indexPath.row]{
            cell.episodeName.text = episode.name
            cell.episodeNumber.text = "Episode \(episode.number)"
            if let image = episode.image {
                cell.episodeImage.load(url: image.medium)
            }
            cell.squareView.layer.cornerRadius = 10
            seasonLabel.text = "Season: \(episode.season)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 230, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "episodeSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedPath = episodesCollection.indexPathsForSelectedItems?.last?.row else { return }
        if let target = segue.destination as? EpisodeViewController {
            target.selectedEpisode = selectedShow?._embedded?.episodes![selectedPath]
        }
    }
}
