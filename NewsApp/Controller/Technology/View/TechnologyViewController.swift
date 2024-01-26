//  TechnologyViewController.swift
//  NewsApp
//
//  Created by Vitaly on 30.11.2023.
//

import UIKit
import SnapKit

final class TechnologyViewController: UIViewController {
    
    //MARK: - GUI Variables
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20,
                                           left: 20,
                                           bottom: 20,
                                           right: 20)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: view.frame.width, height: view.frame.height),
                                              collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK: - Properties
    private var viewModel: TechnologyViewModel
    
    //MARK: - Life Cycle
    init(viewModel: TechnologyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        
        self.setupViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupViewModel() {
        
        viewModel.reloadData = { [ weak self ] in
            self?.collectionView.reloadData()
        }
        
        viewModel.reloadCell = { [ weak self ] row in
            row == 0 ?
            self?.collectionView.reloadItems(at: [IndexPath.init(row: row, section: 0)]) :
            self?.collectionView.reloadItems(at: [IndexPath.init(row: row - 1, section: 1)])
        }
        
        viewModel.showError = { error in
            print(error)
        }
    }
    
    //MARK: - Privat methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(GeneralCollectionViewCell.self, forCellWithReuseIdentifier: "GeneralCollectionViewCell")
        collectionView.register(TechnologyDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "TechnologyDetailsCollectionViewCell")
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension TechnologyViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let article = viewModel.sections[indexPath.section].items[indexPath.row ] as? ArticleCellViewModel else { return UICollectionViewCell()}
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GeneralCollectionViewCell", for: indexPath) as? GeneralCollectionViewCell else { return UICollectionViewCell()}
            cell.set(article: article)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TechnologyDetailsCollectionViewCell", for: indexPath) as? TechnologyDetailsCollectionViewCell
                    
            else { return UICollectionViewCell()}
            cell.set(article: article)
            return cell
        }
    }
}
//MARK: - UICollectionViewDelegate
extension TechnologyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let article = viewModel.sections[indexPath.section].items[indexPath.row] as? ArticleCellViewModel else { return }
        
        navigationController?.pushViewController(NewsViewController(viewModel: NewsViewModel(article: article)), animated: true)
    }
    //MARK: - Infinite Scroll
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel.sections[1].items.count - 15) {
            //Load data
            viewModel.loadData(searchText: nil)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TechnologyViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let firstSectionItemSize = CGSize(width: width,
                                          height: width )
        let secondSectionItemSize = CGSize(width: width,
                                           height: 100)
        
        return indexPath.section == 0 ? firstSectionItemSize : secondSectionItemSize
    }
}
