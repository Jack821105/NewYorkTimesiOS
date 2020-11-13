//
//  NewsDetailViewController.swift
//  NewYorkTimesiOS
//
//  Created by 許自翔 on 2020/11/13.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    var resultsDetail: News? = nil
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var published_dateLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let resultsDetail = resultsDetail{
            titleLabel.text = resultsDetail.title
            abstractLabel.text = resultsDetail.abstract
            published_dateLabel.text = resultsDetail.published_date
            
            resultsDetail.media.forEach {[weak self] (Media) in
                guard let self = self else {
                    return
                }
                Media.metadata.forEach {[weak self] (Metadata) in
                    guard let self = self else {return}
                    Network.shared.fetchImage(pathUrl: Metadata.imageUrl) { [weak self](image) in
                        guard let image = image else{
                            return
                        }
                        DispatchQueue.main.async {
                            self?.newsImage.image = image
                        }
                    }
                }
            }
            
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
