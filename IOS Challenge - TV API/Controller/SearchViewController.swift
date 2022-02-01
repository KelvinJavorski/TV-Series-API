//
//  ViewController.swift
//  IOS Challenge - TV API
//
//  Created by Kelvin Javorski Soares on 30/01/22.
//

import UIKit

class ShowViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var shows = [Show]()

    func searchShows(named name: String){
        let queryStr = formatToQueryString(name)
        let fullURL = "\(ENDPOINT)search/shows?q=\(queryStr)"
        

        DispatchQueue.main.async {
            guard let url = URL(string: fullURL),
            let data = try? Data(contentsOf: url) else { return }

            if let search = try? JSONDecoder().decode([Search].self, from: data) {
                for found in search {
                    self.shows.append(found.show)
                }
            } else {
                print("Decode error")
            }
        }
    }
    
    func formatToQueryString(_ string: String) -> String {
        return string.components(separatedBy: " ").joined(separator: "%20")
    }
    
    @IBAction func searchButtonTouched(_ sender: UIButton){
//        dismissKeyboard()
        guard let text = nameTextField.text,
              text.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        let name = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchShows(named: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

