//
//  MovieListViewController.swift
//  MovieListSmartDevAssignment-Swift
//
//  Created by Tran Tuyen on 20/03/2023.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var loadingView: UIView!
    
    private var viewModel: IMovieListViewModel = MovieListViewModel()
    private var isWaitingLoadMore: Bool = false
    private var searchText: String {
        return searchTextfield.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        viewModel.initListMovie(text: searchText)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        searchTextfield.resignFirstResponder()
    }
    
    private func setupUI() {
        // Collection View
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        // Textfield
        searchTextfield.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.isWaitingLoadMore = false
            }
        }
        
        viewModel.showLoading = { [weak self] isShow in
            DispatchQueue.main.async { [weak self] in
                self?.loadingView.isHidden = !isShow
            }
        }
    }
    
}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
            let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
            
            return CGSize(width:widthPerItem, height:widthPerItem*4/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMoviesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieItemCell", for: indexPath) as! MovieItemCell
        if let data = viewModel.getMovie(indexPath.item) {
            cell.setData(data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.viewModel.getMoviesCount() > 4 &&
            indexPath.item == self.viewModel.getMoviesCount() - 4 &&
            !isWaitingLoadMore {
            isWaitingLoadMore = true
            self.viewModel.loadMoreListMovie(text: searchText)
        }
    }
    
}

extension MovieListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cancelButton.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        viewModel.initListMovie(text: searchText)
        return true
    }
}
