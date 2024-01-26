//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Vitaly on 08.12.2023.
//

import UIKit
import SnapKit

final class NewsViewController: UIViewController {
    
    //MARK: - GUI Variables
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    private var contentView: UIView = UIView()
    
    private var titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.white.withAlphaComponent(0.5)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 17, weight: .bold)
        title.numberOfLines = 0
        
        return title
    }()
    
    private var imageView: UIImageView = {
        let view = UIImageView ()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        return label
    }()
    
    private var dataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        
        return label
    }()
    
    //MARK: - Private
    private let equalInset = 5
    private let equalOffset = 30
    private let viewModel: NewsViewModelProtocol
    
    //MARK: - Properties
    private let edgeInset = 10
    
    //MARK: - Life cycle
    init(viewModel: NewsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        contentView.addSubview(imageView)
        contentView.addSubview(dataLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.text = viewModel.title
        dataLabel.text = viewModel.date
        descriptionLabel.text = viewModel.description
        if let data = viewModel  .imageData,
           let image = UIImage(data: data){
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "image")
        }
        
        configureConstraints()
    }
    
    //MARK: - Constraints
    func configureConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.edges.equalTo(scrollView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }
        
        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(edgeInset)
            make.leading.trailing.equalToSuperview().inset(edgeInset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(edgeInset)
            make.leading.trailing.equalToSuperview().inset(edgeInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(edgeInset)
            make.leading.trailing.equalToSuperview().inset(edgeInset)
            make.bottom.equalToSuperview().inset(edgeInset)
        }
    }
}
