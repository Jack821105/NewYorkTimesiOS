//
//  NewsCollectionViewController.swift
//  NewYorkTimesiOS
//
//  Created by 許自翔 on 2020/10/27.
//

import UIKit


private let reuseIdentifier = "Cell"

class NewsCollectionViewController: UICollectionViewController {
    
    var results:Results?
    var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //控制cell
        let itemSpace: CGFloat = 1
        let columnCount: CGFloat = 1
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width  - itemSpace * (columnCount)) / columnCount)
        print("width",width, collectionView.bounds)
        flowLayout?.itemSize = CGSize(width: 440, height: 293)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        loadData()
        
  
        
    }
    
    func loadData() {
        Network.shared.fetchData { [weak self](ResultsData) in
            guard let self = self else{return}
            
             if ResultsData != nil{
                self.results = ResultsData
            }
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                
            }
            
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        guard let results = results else {
            return 0
        }
        return results.results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NewsCollectionViewCell.self)", for: indexPath) as? NewsCollectionViewCell  else {
            return UICollectionViewCell()
        }
        let news = results?.results[indexPath.row]
        news?.media.forEach({[weak self] (Media) in
            guard let self = self else{ return }
            Media.metadata.filter { [weak self] (Metadata) -> Bool in
                Metadata.imageUrl != nil
            }
            Media.metadata.forEach { [weak self](Metadata) in
                guard let self = self else{ return }
                Network.shared.fetchImage(pathUrl: Metadata.imageUrl) { [weak self](newsPhoto: UIImage?) in
                    guard let newsPhoto = newsPhoto else {return}
                    DispatchQueue.main.async {
                        cell.newsPhoto.image = newsPhoto
                    }
                }
            }
        })
       
        cell.newsPhoto.image = UIImage(systemName: "questionmark.circle")
        cell.titleLable.text = news?.title
        
        return cell
    }
    
    
    @IBSegueAction func actionToNewDetail(_ coder: NSCoder) -> NewsDetailViewController? {
        
        let controller = NewsDetailViewController(coder: coder)
        
        if let row = collectionView.indexPathsForSelectedItems?.first?.row{
            controller?.resultsDetail = results?.results[row]
        }
        
        return controller
    }
    
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
}

