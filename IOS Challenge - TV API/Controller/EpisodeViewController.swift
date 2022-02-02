//
//  EpisodeViewController.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 01/02/22.
//

import UIKit

class EpisodeViewController: UIViewController {

    var selectedEpisode: Episode?
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var episodeSeason: UILabel!
    @IBOutlet weak var episodeSummary: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodes()
        setEpisodeInformations()
    }
    
    func loadEpisodes(){
        if let selectedEpisode = selectedEpisode {
            let fullUrl = "\(ENDPOINT)episodes/\(selectedEpisode.id)"
            
            DispatchQueue.main.async {
                guard let url = URL(string: fullUrl),
                let data = try? Data(contentsOf: url) else { return }
                
                if let episode = try? JSONDecoder().decode(Episode.self, from: data){
                    self.selectedEpisode = episode
                } else {
                    print("Decode error")
                }
            }
        }
    }
    
    func setEpisodeInformations(){
        if let episode = selectedEpisode{
            episodeName.text = episode.name
            if let image = episode.image {
                episodeImage.load(url: image.medium)
            }
            episodeSeason.text = "Season: \(episode.season)"
            episodeNumber.text = "Number: \(episode.number)"

            if let summary = episode.summary {
                episodeSummary.text = summary.htmlToString
            }
        }
           
    }

}
