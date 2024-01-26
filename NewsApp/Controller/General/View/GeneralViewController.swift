//  GeneralViewController.swift
//  NewsApp
//
//  Created by Vitaly on 30.11.2023.
//

import UIKit
import SnapKit

final class GeneralViewController: UIViewController {
    
    //MARK: - GUI Variables
    private lazy var searchBar: UISearchBar = {
        let controller = UISearchBar()
        controller.placeholder = "Search for News"
        let defaultOffset = view.safeAreaInsets.top
        controller.delegate = self
        
        return controller
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.width
        
        layout.itemSize = CGSize(width: width, height: width )
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: view.frame.width, height: view.frame.height - searchBar.frame.height),
                                              collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK: - Properties
    private var viewModel: NewsListViewModelProtocol
    
    //MARK: - Life Cycle
    init(viewModel: NewsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadData(searchText: nil)
    }
    
    //MARK: - Methods
    private func setupViewModel() {
        
        viewModel.reloadData = { [ weak self ] in
            self?.collectionView.reloadData()
        }
        
        viewModel.reloadCell = { [ weak self ] row in
            self?.collectionView.reloadItems(at: [IndexPath(row: row,
                                                            section: 0)])
        }
        
        viewModel.showError = { error in
            //TODO: show alert with error
            print(error)
        }
    }
    
    //MARK: - Privat methods
    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        collectionView.register(GeneralCollectionViewCell.self, forCellWithReuseIdentifier: "GeneralCollectionViewCell")
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension GeneralViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        viewModel.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let article = viewModel.sections[indexPath.section].items[indexPath.row ] as? ArticleCellViewModel,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralCollectionViewCell",
                                                            for: indexPath) as? GeneralCollectionViewCell else {
            return UICollectionViewCell() }
        
        cell.set(article: article)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension GeneralViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let article = viewModel.sections[indexPath.section].items[indexPath.row] as? ArticleCellViewModel else { return }
        
        navigationController?.pushViewController(NewsViewController(viewModel: NewsViewModel(article: article)), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, offset))
    }
    //MARK: - Infinite Scroll
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.sections[0].items.count - 15) {
            viewModel.loadData(searchText: nil)
        }
    }
}

//MARK: - UISearchBarDelegate
extension GeneralViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.loadData(searchText: text)
        searchBar.searchTextField.resignFirstResponder()
    }
}
