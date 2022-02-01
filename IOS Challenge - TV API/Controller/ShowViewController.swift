//
//  ShowViewController.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 31/01/22.
//

import UIKit

class ShowViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            cell.episodeSeason.text = "Season: \(episode.season)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
    
    var selectedShow : Show?
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timeAirLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var episodesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        episodesCollection.delegate = self
        episodesCollection.dataSource = self
        episodesCollection.reloadData()
        episodesCollection.decelerationRate = UIScrollView.DecelerationRate.normal
        setShowInformations()
        // Do any additional setup after loading the view.
    }

    func loadEpisodes(named name: String){
        let fullUrl = "\(ENDPOINT)singlesearch/shows?q=\(name)&embed=episodes"
        
        DispatchQueue.main.async {
            guard let url = URL(string: fullUrl),
            let data = try? Data(contentsOf: url) else { return }
            
            if let show = try? JSONDecoder().decode(Show.self, from: data){
                self.selectedShow = show
            } else {
                print("Decode error")
            }
        }
    }
    
    func setShowInformations(){
        if let show = selectedShow{
            showLabel.text = show.name
            if let image = show.image {
                posterImageView.load(url: image.medium)
            }
            let concatenatedGenres = show.genres.joined(separator: "\n")
            genreLabel.text = concatenatedGenres
            if let runtime = show.runtime{
                timeAirLabel.text = String(runtime)
            }
            summaryLabel.text = show.summary
            loadEpisodes(named: show.name)
        }
           
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
