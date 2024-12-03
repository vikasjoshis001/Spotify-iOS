//
//  ViewController.swift
//  Spotify-Clone
//
//  Created by Vikas Joshi on 20/11/24.
//

import UIKit

// MARK: - BrowseSectionType

enum BrowseSectionType {
    case newReleases(viewModel: [NewReleasesCellViewModel]) // 1
    case categories(viewModel: [CategoriesCellViewModel]) // 2
    
    var title: String {
        switch self {
            case .newReleases:
                return "New Released Albums"
            case .categories:
                return "Top Catrgories"
        }
    }
}

// MARK: - HomeViewController

class HomeViewController: UIViewController {
    private var newReleases: [Album] = []
    private var categories: [CategoryItems] = []
    
    private var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            HomeViewController.createSectionLayout(section: sectionIndex)
        })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections: [BrowseSectionType] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: Constants.NEW_RELEASE)
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: Constants.CATEGORIES)
        collectionView.register(TitleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.TITLE_HEADER)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
            case 0: createNewReleasesLayout()
            case 1: createCategoriesLayout()
            default: createDefaultLayout()
        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureModels(newAlbums: [Album],
                                 categories: [CategoryItems])
    {
        newReleases = newAlbums
        self.categories = categories
        
        sections.append(.newReleases(viewModel: newAlbums.compactMap {
            NewReleasesCellViewModel(name: $0.name,
                                     artworkURL: URL(string: $0.images.first?.url ?? ""),
                                     numberOfTracks: $0.total_tracks,
                                     artistName: $0.artists.first?.name ?? "-")
        }))
        sections.append(.categories(viewModel: categories.compactMap {
            CategoriesCellViewModel(categoryCoverImageURL: URL(string: $0.icons.first?.url ?? ""),
                                    categoryName: $0.name)
        }))
        collectionView.reloadData()
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse? = nil
        var categories: CategoryResponse? = nil

        // Calling `getNewReleases` API
        APICaller.shared.getNewReleases { response in
            defer {
                group.leave()
            }
            switch response {
                case .success(let model):
                    newReleases = model
                case .failure(let error):
                    debugPrint("getNewReleases", error.localizedDescription)
            }
        }
        
        // Calling `getCategories` API
        APICaller.shared.getCategories { response in
            defer {
                group.leave()
            }
            switch response {
                case .success(let model):
                    categories = model
                case .failure(let error):
                    debugPrint("getCategories", error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let newAlbums = newReleases?.albums.items,
                  let categories = categories?.categories.items
            else {
                return
            }
            self.configureModels(newAlbums: newAlbums,
                                 categories: categories)
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
            case .newReleases(let viewModels):
                return viewModels.count
            case .categories(let viewModels):
                return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
            case .newReleases:
                let album = newReleases[indexPath.row]
                let vc = AlbumViewController(album: album)
                vc.title = "Album"
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
//                debugPrint("Album is selected")
            case .categories:
                break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
            case .newReleases(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.NEW_RELEASE, for: indexPath) as? NewReleaseCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let viewModel = viewModels[indexPath.row]
                cell.configure(with: viewModel)
                return cell
                
            case .categories(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CATEGORIES, for: indexPath) as? CategoriesCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let viewModel = viewModels[indexPath.row]
                cell.configure(with: viewModel)
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: Constants.TITLE_HEADER,
                                                                           for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader
        else {
            return UICollectionReusableView()
        }
        let sectionTitle = sections[indexPath.section].title
        header.configure(with: sectionTitle)
        return header
    }
}

// MARK: - Create collection view section layouts

extension HomeViewController {
    private static func createLayoutHeader() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let supplementryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        return supplementryViews
    }
    
    private static func createNewReleasesLayout() -> NSCollectionLayoutSection {
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        
        // Vertical group in horizontal group
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count: 3)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)), subitem: verticalGroup, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = createLayoutHeader()
        return section
    }

    private static func createCategoriesLayout() -> NSCollectionLayoutSection {
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(300)), subitem: item, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = createLayoutHeader()
        return section
    }

    private static func createRecommededTracksLayout() -> NSCollectionLayoutSection {
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        // Group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), subitem: item, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = createLayoutHeader()
        return section
    }

    private static func createDefaultLayout() -> NSCollectionLayoutSection {
        // Item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)), subitem: item, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = createLayoutHeader()
        return section
    }
}
